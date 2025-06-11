//
//  LoginViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 6/9/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

/// 로그인 뷰모델
@Observable
class LoginViewModel {
    
    var isLoginSuccess = false
    let keychainString: String = "widiApp"
    let appleLoginManager = AppleLoginManager.shared
    let keychain = KeychainManager.standard
    
    let container: DIContainer
    
    
    init(container: DIContainer) {
        self.container = container
    }
    
    /// 애플 로그인
    func appleLogin() {
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first {
            appleLoginManager.startSignInWithAppleFlow(presentationAnchor: window) { [weak self] result in
                switch result {
                case .success(let credential):
                    Task {
                        do {
                            let user = try await self?.container.firebaseService.auth.signInWithAppleCredential(credential)
                            self?.saveKeychain(user: user)
                        } catch {
                            print(LoginError.firebaseSignInFailed(error.localizedDescription).localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(LoginError.appleLoginFailed(error).localizedDescription)
                }
            }
        }
    }
    
    /// 키체인 저장
    /// - Parameter user: 유저값 키체인 저장
    private func saveKeychain(user: User?) {
        if let user = user {
            let user = UserKeychain(userUID: user.uid)
            let isSaved = keychain.saveSession(user, for: keychainString)
            
            if isSaved {
                print("👉 키체인 저장 성공")
            } else {
                print("❗️키체인 저장 실패")
            }
        }
    }
}
