//
//  AppleLoginManager.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation
import AuthenticationServices

/// 애플 로그인 매니저
class AppleLoginManager: NSObject {
    
    static let shared = AppleLoginManager()
    
    private var completion: ((Result<ASAuthorizationAppleIDCredential, Error>) -> Void)?
    private var anchor: ASPresentationAnchor?
    
    func startSignInWithAppleFlow(presentationAnchor: ASPresentationAnchor,
                                   completion: @escaping (Result<ASAuthorizationAppleIDCredential, Error>) -> Void) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        self.completion = completion
        self.anchor = presentationAnchor
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            completion?(.success(credential))
        } else {
            completion?(.failure(NSError(domain: "InvalidCredential", code: -1)))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return anchor ?? UIWindow()
    }
}
