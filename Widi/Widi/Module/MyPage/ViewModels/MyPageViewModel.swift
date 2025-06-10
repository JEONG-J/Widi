//
//  MyPageViewModels.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation

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
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Function
    
    func toggleOnOff(oldValue: Bool, newValue: Bool) {
        toggleOption.toggle.toggle()
        
        /* FireBase 연결 */
    }
    
    /// 로그아웃 버튼 함수
    func logOutAction () {
        
    }
    
    /// 탈퇴하기 버튼 함수
    func deleteAccountAction () {
        
        
    }
    
}
