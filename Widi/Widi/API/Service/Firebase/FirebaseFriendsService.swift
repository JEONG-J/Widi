//
//  FirebaseFriendsService.swift
//  Widi
//
//  Created by Apple Coding machine on 6/11/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseFriendsService {
    
    /// 친구 여러 데이터 조회
    /// - Parameter userId: userId 값 기반으로 조회
    /// - Returns: 친구 데이터 조회
    @MainActor
    func fetchFriends(for userId: String) async throws -> [FriendResponse] {
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection("friends")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            var friends: [FriendResponse] = []
            
            for doc in snapshot.documents {
                do {
                    let raw = try doc.data(as: RawFriend.self)
                    
                    let experienceDTO = try await fetchExperience(for: userId, friendId: raw.friendId)
                    
                    let friend = FriendResponse(
                        documentId: doc.documentID,
                        friendId: raw.friendId,
                        name: raw.name,
                        birthday: raw.birthday,
                        experienceDTO: experienceDTO
                    )
                    
                    friends.append(friend)
                } catch {
                    print("디코딩 또는 experience fetch 실패: \(error.localizedDescription)")
                    continue
                }
            }
            
            return friends
            
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
    
    /// 단일 친구 조회
    /// - Parameter documentId: 친구 문서
    /// - Returns: 친구 데이터 반환
    @MainActor
    func fetchFriend(documentId: String) async throws -> FriendResponse {
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection("friends").document(documentId).getDocument()
            
            guard snapshot.exists, let data = snapshot.data() else {
                throw FirebaseServiceError.custom(message: "해당 친구 문서를 찾을 수 없습니다.")
            }

            guard
                let name = data["name"] as? String,
                let friendId = data["friendId"] as? String,
                let userId = data["userId"] as? String
            else {
                throw FirebaseServiceError.custom(message: "친구 데이터가 올바르지 않습니다.")
            }
            
            let birthday = data["birthday"] as? String
            let experienceDTO = try await fetchExperience(for: userId, friendId: friendId)
            
            return FriendResponse(
                documentId: snapshot.documentID,
                friendId: friendId,
                name: name,
                birthday: birthday,
                experienceDTO: experienceDTO
            )
            
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
    
    private func fetchExperience(for userId: String, friendId: String) async throws -> ExperienceDTO {
        let db = Firestore.firestore()
        
        let snapshot = try await db.collection("experiences")
            .whereField("userId", isEqualTo: userId)
            .whereField("friendId", isEqualTo: friendId)
            .getDocuments()
        
        guard let doc = snapshot.documents.first else {
            throw FirebaseServiceError.custom(message: "해당 친구의 경험치 데이터가 없습니다.")
        }

        return try doc.data(as: ExperienceDTO.self)
    }
    
    
    /// 친구 삭제
    /// - Parameter documentId: 친구 문서 아이디
    func deleteFriend(documentId: String) async throws {
        let db = Firestore.firestore()
        
        do {
            try await db.collection("friends").document(documentId).delete()
            print("친구 삭제 완료")
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
    
    /// 친구 정보 수정
    /// - Parameters:
    ///   - documentId: 친구 문서 아이디
    ///   - name: 친구 이름
    ///   - birthday: 친구 생일 정보
    func updateFriendInfo(documentId: String, name: String, birthday: String?) async throws {
        let db = Firestore.firestore()
        var data: [String: Any] = [
            "name": name
        ]
        
        if let birthday = birthday {
            data["birthday"] = birthday
        }
        
        do {
            try await db.collection("friends").document(documentId).updateData(data)
            print("친구 정보 수정 완료")
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
    func addFriend(userId: String, request: FriendRequest) async throws -> String {
        let db = Firestore.firestore()
        
        let generatedFriendId = UUID().uuidString
        let friendRef = db.collection("friends").document()
        let experienceRef = db.collection("experiences").document()
        
        let character = makeRandomCharacter()
        
        let friend = FriendDTO(
            userId: userId,
            friendId: generatedFriendId,
            name: request.name,
            birthday: request.birthday
        )
        
        let experience = ExperienceDTO(
            characterInfo: character,
            exp: 0,
            friendId: generatedFriendId,
            userId: userId
            
        )
        
        do {
            try friendRef.setData(from: friend)
            try experienceRef.setData(from: experience)
            print("친구 및 경험치 등록 완료")
            return generatedFriendId
        } catch {
            throw FirebaseServiceError.custom(message: "친구 등록 실패: \(error.localizedDescription)")
        }
    }
    
    private func makeRandomCharacter() -> CharacterDTO {
        return CharacterDTO(
            imageURL: "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelZero.png?alt=media&token=7fbd4597-5ce2-4e9d-b6ff-036cbae76a8b",
            x: Int(CGFloat.random(in: 20...340)),
            y: Int(CGFloat.random(in: 40...820))
        )
    }
}
