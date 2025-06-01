//
//  FirebaseAuthManager.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import Foundation
import FirebaseAuth
import AuthenticationServices

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
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
}
