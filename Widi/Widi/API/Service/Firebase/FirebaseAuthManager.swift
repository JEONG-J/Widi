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
import FirebaseMessaging

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
                    Messaging.messaging().token { token, error in
                        if let token = token {
                            Firestore.firestore().collection("users").document(user.uid).setData([
                                "fcmToken": token
                            ], merge: true)
                            print("FCM 토큰 저장 완료")
                        } else if let error = error {
                            print("FCM 토큰 저장 실패: \(error.localizedDescription)")
                        }
                    }
                    
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
        
        let name = fullName?.givenName ?? "사용자"
        
        let setting = await UNUserNotificationCenter.current().notificationSettings()
        let isPublished = setting.authorizationStatus == .authorized
        
        let newUser = UserRequest(name: name, toogle: isPublished)
        
        do {
            try userRef.setData(from: newUser, merge: true)
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
    
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else {
            print("현재 로그인된 사용자가 없습니다.")
            return
        }
        
        do {
            let uid = user.uid
            let db = Firestore.firestore()
            try await db.collection("friends").document(uid).delete()
            try await user.delete()
            KeychainManager.standard.deleteSession(for: "widiApp")
            print("탈퇴 완료, 앱 초기화 필요")
            
        } catch {
            print("탈퇴 실패: \(error.localizedDescription)")
        }
    }
}
