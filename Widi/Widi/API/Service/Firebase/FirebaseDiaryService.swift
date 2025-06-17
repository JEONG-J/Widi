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
    
    // MARK: - 일기 조회
    
    /// 일기 조회
    /// - Parameters:
    ///   - userId: 일기 조회 유저 아이디
    ///   - friendId: 친구 아이디
    /// - Returns: 일기 데이터 조회
    func fetchDiaries(for userId: String, friendId: String) async throws -> [DiaryResponse] {
        let db = Firestore.firestore()
        
        do {
            let query = db.collection("diaries")
                        .whereField("userId", isEqualTo: userId)
                        .whereField("friendId", isEqualTo: friendId)
                        .order(by: "createdAt", descending: true)
            
            let snapshop = try await query.getDocuments()
            
            let diaries = try snapshop.documents.compactMap { document -> DiaryResponse in
                var diary = try document.data(as: DiaryResponse.self)
                diary.documentId = document.documentID
                return diary
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
    // MARK: - 일기 삭제
    
    /// 일기 삭제
    /// - Parameter documentId: 일기 문서 아이디
    func deleteDiary(documentId: String) async throws {
        let db = Firestore.firestore()
        
        do {
            let diaryRef = db.collection("diaries").document(documentId)
            let snapshot = try await diaryRef.getDocument()
            
            guard let data = snapshot.data(),
                  let _ = data["friendId"] as? String else {
                throw FirebaseServiceError.custom(message: "friendId를 찾을 수 없습니다.")
            }

            try await diaryRef.delete()
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

    // MARK: - Search
    /// 일기 검색
    /// - Parameters:
    ///   - keyword: 일기 검색 키워드
    ///   - userId: 유저 아이디
    /// - Returns: 일기 데이터 조회
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
                do {
                    var diary = try doc.data(as: DiaryResponse.self)
                    diary.documentId = doc.documentID
                    return diary
                } catch {
                    print("일기 디코딩 실패: \(error.localizedDescription)")
                    return nil
                }
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
    
    // MARK: - Image
    
    /// 이미지 삭제
    /// - Parameters:
    ///   - diaryId: 이미지 속한 일기 아이디
    ///   - imageUrl: 이미지 URL
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
    
    /// 이미지 서버 저장
    /// - Parameters:
    ///   - image: 이미지
    ///   - diaryId: 일기 아이디
    /// - Returns: 이미지 주소
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
    
    // MARK: - 일기 추가 및 수정
    
    /// 일기 및 일기 내 이미지 변경
    /// - Parameters:
    ///   - diaryId: 일기 아이디
    ///   - title: 일기 타이틀 변경
    ///   - content: 일기 주 컨텐츠 내용
    ///   - images: 일기 속 사진
    ///   - originalServerImageURLs: 편집 전 일기 주소 모음
    ///   - diaryDate: 일기 날짜 데이터
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
    
    /// 일기 추가
    /// - Parameters:
    ///   - userId: 앱 사용자 유저 아이디
    ///   - friendId: 일기 주인 친구 id
    ///   - title: 일기 제목
    ///   - content: 일기 컨텐츠
    ///   - images: 일기 내부 사진
    ///   - diaryDate: 일기 속 날짜
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
    
    /// 경험치 증가
    /// - Parameters:
    ///   - userId: 경험치 증가 유저
    ///   - friendId: 일기 친구 아이디
    ///   - point: 증가 포인트
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
                .whereField("friendId", isEqualTo: userId)
                .getDocuments()
            
            return snapshot.count
        } catch {
            throw FirebaseServiceError.custom(message: error.localizedDescription)
        }
    }
}
