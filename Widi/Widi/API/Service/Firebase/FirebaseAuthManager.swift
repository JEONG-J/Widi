//
//  FirebaseAuthManager.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import FirebaseFirestore

/// Firebase 인증 매니저
class FirebaseAuthManager {
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    func signInWithAppleCredential(_ appleIDCredential: ASAuthorizationAppleIDCredential) async throws -> User {
        guard let identityToken = appleIDCredential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            throw NSError(domain: "InvalidTokenError-1", code: -1)
        }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: tokenString,
            rawNonce: nil,
            fullName: appleIDCredential.fullName
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = authResult?.user {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NSError(domain: "UnknownError", code: -1))
                }
            }
        }
    }
    
    @MainActor
    func saveInitialUserData(user: User, fullName: PersonNameComponents?) async throws {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        // givenName만 저장
        let name = fullName?.givenName ?? "사용자"
        
        let data: [String: Any] = [
            "name": name,
            "toggle": true,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        do {
            try await userRef.setData(data, merge: true)
            print("사용자 정보 Firestore에 저장 완료")
        } catch let error as NSError {
            switch error.code {
            case FirestoreErrorCode.permissionDenied.rawValue:
                throw FirebaseServiceError.permissionDenied
            case FirestoreErrorCode.notFound.rawValue:
                throw FirebaseServiceError.documentNotFound
            case NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut:
                throw FirebaseServiceError.networkFailure
            default:
                throw FirebaseServiceError.custom(message: error.localizedDescription)
            }
        } catch {
            throw FirebaseServiceError.unknownError
        }
    }
}
