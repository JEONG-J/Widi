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
            let snapshot = try await db.collection("diaries")
                .whereField("userId", isEqualTo: userId)
                .whereField("friendId", isEqualTo: friendId)
                .order(by: "createdAt", descending: true)
                .getDocuments()
            
            
            let diaries: [DiaryResponse] = snapshot.documents.compactMap { doc in
                let data = doc.data()
                guard
                    let content = data["content"] as? String,
                    let eventDate = data["diaryDate"] as? String
                else { return nil }
                
                let title = data["title"] as? String
                let photos = data["pictures"] as? [String]
                
                return DiaryResponse(
                    documentId: doc.documentID,
                    title: title,
                    content: content,
                    pictures: photos,
                    diaryDate: eventDate
                )
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
    
    func searchDiaries(keyword: String, userId: String) async throws -> [DiaryResponse] {
        let db = Firestore.firestore()
        
        guard !keyword.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }
        
        do {
            let snapshot = try await db.collection("diaries")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            let results = snapshot.documents.compactMap { doc -> DiaryResponse? in
                let data = doc.data()
                guard
                    let content = data["content"] as? String,
                    let eventDate = data["diaryDate"] as? String
                else { return nil }
                
                let title = data["title"] as? String
                let matches = content.localizedCaseInsensitiveContains(keyword) ||
                (title?.localizedCaseInsensitiveContains(keyword) ?? false)
                
                guard matches else { return nil }
                
                return DiaryResponse(
                    documentId: doc.documentID,
                    title: title,
                    content: content,
                    pictures: data["pictures"] as? [String],
                    diaryDate: eventDate
                )
            }
            
            return results
            
        } catch {
            throw FirebaseServiceError.custom(message: error.localizedDescription)
        }
    }
    
    func deleteImage(from diaryId: String, imageUrl: String) async throws {
        let db = Firestore.firestore()
        let ref = db.collection("diaries").document(diaryId)
        
        // Firestore 배열에서 제거
        let snapshot = try await ref.getDocument()
        guard var pictures = snapshot.data()?["pictures"] as? [String] else { return }
        pictures.removeAll(where: { $0 == imageUrl })
        try await ref.updateData(["pictures": pictures])
        
        // Storage 삭제
        let storageRef = Storage.storage().reference(forURL: imageUrl)
        try await storageRef.delete()
    }
    
    func uploadImageToStorage(image: UIImage, diaryId: String) async throws -> String {
        let storage = Storage.storage()
        let imageName = UUID().uuidString
        let ref = storage.reference().child("diary/\(diaryId)/\(imageName).jpg")
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw FirebaseServiceError.custom(message: "이미지를 JPEG 데이터로 변환할 수 없습니다.")
        }
        
        _ = try await ref.putDataAsync(data, metadata: nil)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
    
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
        
        // 현재 서버 이미지 & 로컬 이미지 분리
        let currentServerURLs = images.compactMap {
            if case let .server(url) = $0 { return url }
            return nil
        }
        let newLocalImages = images.compactMap {
            if case let .local(_, original, _) = $0 {
                return original
            }
            return nil
        }
        
        // 삭제된 서버 이미지
        let deletedServerURLs = originalServerImageURLs.filter { !currentServerURLs.contains($0) }
        
        // 삭제
        for url in deletedServerURLs {
            try? await deleteImage(from: diaryId, imageUrl: url)
        }
        
        // 새 이미지 업로드
        var uploadedURLs: [String] = []
        for img in newLocalImages {
            if let url = try? await uploadImageToStorage(image: img, diaryId: diaryId) {
                uploadedURLs.append(url)
            }
        }
        
        // 문서 업데이트
        let allURLs = currentServerURLs + uploadedURLs
        let request = DiaryRequest(
            title: title,
            content: content,
            pictures: allURLs,
            diaryDate: diaryDate
        )
        try ref.setData(from: request, merge: true)
    }
    
    func addDiary(
        userId: String,
        friendId: String,
        title: String?,
        content: String,
        images: [DiaryImage],
        diaryDate: String
    ) async throws {
        let db = Firestore.firestore()
        
        // 1. 로컬 이미지 → UIImage 변환
        let localImages = images.compactMap {
            if case let .local(_, original, _) = $0 {
                return original
            }
            return nil
        }
        
        // 2. Firebase Storage에 업로드
        var uploadedURLs: [String] = []
        let diaryId = UUID().uuidString
        print("localImage:",localImages)
        for img in localImages {
            do {
                let url = try await uploadImageToStorage(image: img, diaryId: diaryId)
                print("업로드 성공:", url)
                uploadedURLs.append(url)
            } catch {
                print("업로드 실패:", error.localizedDescription)
            }
        }
        
        // 3. DiaryRequest 생성
        let request = DiaryRequest(
            title: title,
            content: content,
            pictures: uploadedURLs,
            diaryDate: diaryDate
        )
        
        // 4. Firestore 저장
        let ref = db.collection("diaries").document()
        var data = try Firestore.Encoder().encode(request)
        data["userId"] = userId
        data["friendId"] = friendId
        data["createdAt"] = FieldValue.serverTimestamp()
        
        try await ref.setData(data)
        
        try await increaseExperience(userId: userId, friendId: friendId, by: 1)
    }
    
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

        var newImageURL: String? = nil

        // 레벨 조건에 따라 캐릭터 이미지 갱신
        switch newExp {
        case 2:
            newImageURL = "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelOne.png?alt=media&token=348a327c-77ba-4af9-9e31-4d35000c7781"
        case 4:
            let level4Images = [
                "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelFourA.png?alt=media&token=28d478e1-a07b-49be-a3fd-09b09eba7ffa",
                "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelFourB.png?alt=media&token=d5e868d8-d21b-4be2-9bd7-682e0451f198",
                "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelFourC.png?alt=media&token=75e96b0f-68db-47d7-82b2-228920b3957f",
                "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelFourD.png?alt=media&token=b5c1f745-b685-4f93-a300-f86d1786a32c",
                "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelFourE.png?alt=media&token=efe6e68e-7b38-4347-845d-1ca2d7942bce",
                "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelFourF.png?alt=media&token=ee6de20d-423b-4765-b82f-ec9c50677080",
                "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelFourG.png?alt=media&token=46ee759a-5a9f-4d35-94e8-cc5f3762bd72"
            ]
            newImageURL = level4Images.randomElement()
        default:
            break
        }

        var updateData: [String: Any] = ["exp": newExp]

        if let newImageURL {
            updateData["characterInfo.imageURL"] = newImageURL
        }

        try await doc.reference.updateData(updateData)
    }
}
