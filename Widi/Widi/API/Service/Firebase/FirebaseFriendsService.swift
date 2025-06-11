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
            // 1. friends 문서 가져오기
            let friendsSnapshot = try await db.collection("friends")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            var results: [FriendResponse] = []
            
            for doc in friendsSnapshot.documents {
                let data = doc.data()
                guard
                    let name = data["name"] as? String,
                    let birthday = data["birthday"] as? String,
                    let friendId = data["friendId"] as? String
                else { continue }

                // 2. experiences 문서에서 해당 친구의 경험치 가져오기
                let expSnapshot = try await db.collection("experiences")
                    .whereField("userId", isEqualTo: userId)
                    .whereField("friendId", isEqualTo: friendId)
                    .getDocuments()

                let expDoc = expSnapshot.documents.first
                let exp = expDoc?.data()["exp"] as? Int ?? 0
                
                // 3. FriendResponse 구성
                let friend = FriendResponse(
                    name: name,
                    birthDay: birthday,
                    experienceDTO: .init(experiencePoint: exp)
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
}
