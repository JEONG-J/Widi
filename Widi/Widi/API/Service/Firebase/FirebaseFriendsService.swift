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
    
    /// 친구 데이터 조회
    /// - Parameter userId: userId 값 기반으로 조회
    /// - Returns: 친구 데이터 조회
    func fetchFriends(for userId: String) async throws -> [FriendResponse] {
        let db = Firestore.firestore()
        
        do {
            let friendsSnapshot = try await db.collection("friends")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            var results: [FriendResponse] = []
            
            for doc in friendsSnapshot.documents {
                let data = doc.data()
                guard
                    let name = data["name"] as? String,
                    let friendId = data["friendId"] as? String
                else { continue }
                
                let birthday = data["birthday"] as? String
                
                let expSnapshot = try await db.collection("experiences")
                    .whereField("userId", isEqualTo: userId)
                    .whereField("friendId", isEqualTo: friendId)
                    .getDocuments()
                
                guard let expDoc = expSnapshot.documents.first else { continue }
                let expData = expDoc.data()
                let exp = expData["exp"] as? Int ?? 0
                
                let characterData = expData["characterInfo"] as? [String: Any]
                let character = CharacterDTO(
                    imageURL: characterData?["imageURL"] as? String ?? "",
                    x: characterData?["x"] as? Int ?? 0,
                    y: characterData?["y"] as? Int ?? 0
                )
                
                let friend = FriendResponse(
                    documentId: doc.documentID,
                    friendId: friendId,
                    name: name,
                    birthday: birthday,
                    experienceDTO: .init(
                        experiencePoint: exp,
                        characterInfo: character
                    )
                )
                results.append(friend)
            }
            
            return results
            
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
    
    func addFriend(userId: String, request: FriendRequest) async throws -> String {
        let db = Firestore.firestore()
        
        let generatedFriendId = UUID().uuidString
        let friendRef = db.collection("friends").document()
        let experienceRef = db.collection("experiences").document()
        
        // 랜덤 캐릭터 위치
        let character = CharacterDTO(
            imageURL: "https://firebasestorage.googleapis.com/v0/b/hatchlog-e6a21.firebasestorage.app/o/Character%2FlevelZero.png?alt=media&token=0ded3e91-a7ec-4354-885b-020d5c77ba97",
            x: Int(CGFloat.random(in: 50...393)),
            y: Int(CGFloat.random(in: 100...852))
        )
        
        // 친구 필드
        var friendData: [String: Any] = [
            "userId": userId,
            "friendId": generatedFriendId,
            "name": request.name,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        if let birthday = request.birthday {
            friendData["birthday"] = birthday
        }
        
        // 경험치 필드
        let expData: [String: Any] = [
            "userId": userId,
            "friendId": generatedFriendId,
            "exp": 0,
            "characterInfo": [
                "imageURL": character.imageURL,
                "x": character.x,
                "y": character.y
            ]
        ]
        
        do {
            try await friendRef.setData(friendData)
            try await experienceRef.setData(expData)
            print("친구 및 초기 경험치 등록 완료")
            return generatedFriendId
        } catch {
            throw FirebaseServiceError.custom(message: error.localizedDescription)
        }
    }
    
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
            
            // 경험치 및 캐릭터 정보 가져오기
            let expSnapshot = try await db.collection("experiences")
                .whereField("userId", isEqualTo: userId)
                .whereField("friendId", isEqualTo: friendId)
                .getDocuments()
            
            guard let expDoc = expSnapshot.documents.first else {
                throw FirebaseServiceError.custom(message: "해당 친구의 경험치 데이터가 없습니다.")
            }

            let expData = expDoc.data()
            let exp = expData["exp"] as? Int ?? 0
            
            let characterData = expData["characterInfo"] as? [String: Any]
            let character = CharacterDTO(
                imageURL: characterData?["imageURL"] as? String ?? "",
                x: characterData?["x"] as? Int ?? 0,
                y: characterData?["y"] as? Int ?? 0
            )
            
            return FriendResponse(
                documentId: snapshot.documentID,
                friendId: friendId,
                name: name,
                birthday: birthday,
                experienceDTO: .init(
                    experiencePoint: exp,
                    characterInfo: character
                )
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
}
