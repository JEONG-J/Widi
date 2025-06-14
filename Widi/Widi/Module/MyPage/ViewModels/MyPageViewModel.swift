//
//  MyPageViewModels.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation
import FirebaseAuth

/// 마이페이지 뷰모델
@Observable
class MyPageViewModel {
    
    // MARK: - Property
    
    /// toggle 정보
    var toggleOption: ToggleOptionDTO = .init(toggle: true)
    /// 앱 버전
    var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        return version
    }
    /// 문의하기 모달 띄우기
    var isModalPresented: Bool = false
    var isShowLogoutAlert: Bool = false
    var isShowDrawAlert: Bool = false
    
    private var container: DIContainer
    private var appFlowViewModel: AppFlowViewModel
    
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.container = container
        self.appFlowViewModel = appFlowViewModel
    }
    
    // MARK: - Function
    
    func toggleOnOff(oldValue: Bool, newValue: Bool) {
        toggleOption.toggle.toggle()
        
        
    }
    
    /// 로그아웃 버튼 함수
    func logOutAction () async {
        do {
            try Auth.auth().signOut()
            self.isShowLogoutAlert = false
            KeychainManager.standard.deleteSession(for: "widiApp")
            appFlowViewModel.appState = .login
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    /// 탈퇴하기 버튼 함수
    func deleteAccountAction() async {
        await container.firebaseService.auth.deleteAccount()
    }
    
}
