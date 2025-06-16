//
//  AppFlowViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation
import FirebaseAuth

/// 앱 플로우 뷰모델
class AppFlowViewModel: ObservableObject {
    
    @Published var appState: AppState = .splash
    
    enum AppState {
        case splash
        case login
        case home
    }
    
    @MainActor
    func configureInitialAppState() async {
        let initialState = await self.checkAuthStateAndDetermineInitialState()
        self.appState = initialState
    }
    
    /// 세션 유효성 검사 + 키체인 확인 → 진입 상태 결정
    private func checkAuthStateAndDetermineInitialState() async -> AppFlowViewModel.AppState {
        guard let _ = KeychainManager.standard.loadSession(for: "widiApp") else {
            print("🔓 키체인에 저장된 세션 없음 → 로그인으로 이동")
            return .login
        }

        guard let user = Auth.auth().currentUser else {
            print("❌ Firebase 사용자 없음 → 로그인으로 이동")
            return .login
        }

        do {
            try await user.reload()
            guard let refreshedUser = Auth.auth().currentUser else {
                print("🚫 사용자 없음 (삭제됨) → 로그인으로 이동")
                return .login
            }

            _ = try await refreshedUser.getIDToken()
            print("✅ Firebase 세션 유효 - UID: \(refreshedUser.uid) → 홈으로 이동")
            return .home
        } catch {
            print("⚠️ Firebase 세션 만료 또는 삭제 → 로그인으로 이동")
            return .login
        }
    }
}
