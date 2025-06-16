//
//  FirebaseDiaryService.swift
//  Widi
//
//  Created by Apple Coding machine on 6/11/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class FirebaseDiaryService {
    func fetchDiaries(for userId: String, friendId: String) async throws -> [DiaryResponse] {
        let db = Firestore.firestore()
        
        do {
            let query = db.collection("diaries")
                        .whereField("userId", isEqualTo: userId)
                        .whereField("friendId", isEqualTo: friendId)
                        .order(by: "createdAt", descending: true)
            
            let snapshop = try await query.getDocuments()
            
            let diaries = try snapshop.documents.compactMap { document in
                try document.data(as: DiaryResponse.self)
            }
            
            return diaries
            
        } catch let error as NSError {
            switch error.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut:
                throw FirebaseServiceError.networkFailure
            case FirestoreErrorCode.permissionDenied.rawValue:
                throw FirebaseServiceError.permissionDenied
            default:
                throw FirebaseServiceError.custom(message: error.localizedDescription)
            }
        } catch {
            throw FirebaseServiceError.unknownError
        }
    }
    
    func deleteDiary(documentId: String) async throws {
        let db = Firestore.firestore()
        
        do {
            try await db.collection("diaries").document(documentId).delete()
            print("일기 삭제 완료")
        } catch let error as NSError {
            switch error.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut:
                throw FirebaseServiceError.networkFailure
            case FirestoreErrorCode.permissionDenied.rawValue:
                throw FirebaseServiceError.permissionDenied
            default:
                throw FirebaseServiceError.custom(message: error.localizedDescription)
            }
        } catch {
            throw FirebaseServiceError.unknownError
        }
    }

    @MainActor
    func searchDiaries(keyword: String, userId: String) async throws -> [DiaryResponse] {
        let db = Firestore.firestore()
        
        guard !keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        do {
            let snapshot = try await db.collection("diaries")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            let allDiaries: [DiaryResponse] = snapshot.documents.compactMap { doc in
                try? doc.data(as: DiaryResponse.self)
            }
            
            let filtered = allDiaries.filter { diary in
                diary.content.localizedCaseInsensitiveContains(keyword) ||
                (diary.title?.localizedCaseInsensitiveContains(keyword) ?? false)
            }
            
            return filtered
            
        } catch {
            throw FirebaseServiceError.custom(message: error.localizedDescription)
        }
    }
    
    func deleteImage(from diaryId: String, imageUrl: String) async throws {
        let db = Firestore.firestore()
        let ref = db.collection("diaries").document(diaryId)
        
        let snapshot = try await ref.getDocument()
        guard var pictures = snapshot.data()?["pictures"] as? [String] else { return }
        pictures.removeAll(where: { $0 == imageUrl })
        try await ref.updateData(["pictures": pictures])
        
        let storageRef = Storage.storage().reference(forURL: imageUrl)
        try await storageRef.delete()
    }
    
    func uploadImageToStorage(image: UIImage, diaryId: String) async throws -> String {
        let storage = Storage.storage()
        let imageName = UUID().uuidString
        let ref = storage.reference().child("diary/\(diaryId)/\(imageName).jpg")
        
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            throw FirebaseServiceError.custom(message: "이미지를 JPEG 데이터로 변환할 수 없습니다.")
        }
        
        _ = try await ref.putDataAsync(data, metadata: nil)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
    
    @MainActor
    func updateDiaryWithImages(
        diaryId: String,
        title: String?,
        content: String,
        images: [DiaryImage],
        originalServerImageURLs: [String],
        diaryDate: String
    ) async throws {
        let db = Firestore.firestore()
        let ref = db.collection("diaries").document(diaryId)

        let currentServerURLs = images.compactMap {
            if case let .server(url) = $0 { return url }
            return nil
        }

        let newLocalImages = images.compactMap {
            if case let .local(_, original, _) = $0 { return original }
            return nil
        }

        let deletedServerURLs = originalServerImageURLs.filter { !currentServerURLs.contains($0) }
        for url in deletedServerURLs {
            try? await deleteImage(from: diaryId, imageUrl: url)
        }

        var uploadedURLs: [String] = []
        for img in newLocalImages {
            if let url = try? await uploadImageToStorage(image: img, diaryId: diaryId) {
                uploadedURLs.append(url)
            }
        }
        let allURLs = currentServerURLs + uploadedURLs
        let request = DiaryUpdateRequest(
            title: title,
            content: content,
            pictures: allURLs,
            diaryDate: diaryDate
        )
        try ref.setData(from: request, merge: true)
    }
    
    @MainActor
    func addDiary(
        userId: String,
        friendId: String,
        title: String?,
        content: String,
        images: [DiaryImage],
        diaryDate: String
    ) async throws {
        let db = Firestore.firestore()
        let diaryId = UUID().uuidString
        let ref = db.collection("diaries").document(diaryId)

        let localImages = images.compactMap {
            if case let .local(_, original, _) = $0 { return original }
            return nil
        }

        var uploadedURLs: [String] = []
        for img in localImages {
            do {
                let url = try await uploadImageToStorage(image: img, diaryId: diaryId)
                print("업로드 성공:", url)
                uploadedURLs.append(url)
            } catch {
                print("업로드 실패:", error.localizedDescription)
            }
        }

        let request = DiaryRequest(
            title: title,
            content: content,
            pictures: uploadedURLs,
            diaryDate: diaryDate,
            userId: userId,
            friendId: friendId,
            createdAt: nil
        )
        
        try ref.setData(from: request)
        try await increaseExperience(userId: userId, friendId: friendId, by: 1)
    }
    
    @MainActor
    func increaseExperience(userId: String, friendId: String, by point: Int = 1) async throws {
        let db = Firestore.firestore()
        
        let query = try await db.collection("experiences")
            .whereField("userId", isEqualTo: userId)
            .whereField("friendId", isEqualTo: friendId)
            .getDocuments()

        guard let doc = query.documents.first else {
            throw FirebaseServiceError.documentNotFound
        }

        let currentExp = doc.data()["exp"] as? Int ?? 0
        let newExp = currentExp + point

        var updatedFields: [String: Any] = ["exp": newExp]

        if let newImageURL = imageURL(for: newExp) {
            updatedFields["characterInfo.imageURL"] = newImageURL
        }

        try await doc.reference.updateData(updatedFields)
    }
    
    private func imageURL(for exp: Int) -> String? {
        switch exp {
        case 2:
            return CharacterLevelImage.level2
        case 4:
            return CharacterLevelImage.level4Options.randomElement()
        default:
            return nil
        }
    }
    
    @MainActor
    func getDiaryCount(for userId: String) async throws -> Int {
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection("diaries")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            return snapshot.count
        } catch {
            throw FirebaseServiceError.custom(message: error.localizedDescription)
        }
    }
}
