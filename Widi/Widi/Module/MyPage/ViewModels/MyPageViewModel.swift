//
//  MyPageViewModels.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation
import FirebaseAuth
import UserNotifications
import UIKit

/// 마이페이지 뷰모델
@Observable
class MyPageViewModel {
    
    // MARK: - Property
    /// 앱 버전
    var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        return version
    }
    
    var userInfo: UserResponse?
    
    // MARK: - StateProperty
    var isModalPresented: Bool = false
    var isShowLogoutAlert: Bool = false
    var isShowDrawAlert: Bool = false
    var isLoading: Bool = true
    
    private var container: DIContainer
    private var appFlowViewModel: AppFlowViewModel
    
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.container = container
        self.appFlowViewModel = appFlowViewModel
    }
    
    // MARK: - Function
    
    /// 토글 관련 함수
    @MainActor
    func toggleOnOff() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        let isPushEnabled = settings.authorizationStatus == .authorized

        if isPushEnabled {
            do {
                try await container.firebaseService.myPage.updateToggle(to: true)
                print("푸시 알림 허용 상태 → 서버에 true 저장")
            } catch {
                print("서버에 toggle 저장 실패: \(error.localizedDescription)")
            }
        } else {
            print("푸시 알림 비허용 상태 → 설정 앱으로 유도")
            openSystemSettingNotification()
            
            do {
                try await container.firebaseService.myPage.updateToggle(to: false)
                print("푸시 알림 비허용 상태 → 서버에 false 저장")
            } catch {
                print("서버에 toggle 저장 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func openSystemSettingNotification() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    /// 유저 정보 조회
    @MainActor
    func getMyInfo() async {
        do {
            let userInfo = try await container.firebaseService.myPage.fetchMyInfo()
            self.userInfo = userInfo
            isLoading = false
        } catch {
            print("내 정보 불러오기 실패: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    
    
    /// 로그아웃 버튼 함수
    @MainActor
    func logOutAction () async {
        do {
            try Auth.auth().signOut()
            self.isShowLogoutAlert = false
            KeychainManager.standard.deleteSession(for: "widiApp")
            appFlowViewModel.appState = .login
            container.navigationRouter.popToRooteView()
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    /// 탈퇴하기 버튼 함수
    func deleteAccountAction() async {
        await container.firebaseService.auth.deleteAccount()
    }
    
}
