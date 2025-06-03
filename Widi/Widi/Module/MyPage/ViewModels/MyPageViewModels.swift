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
    // TODO: - FireBase에서 정보 가져와야 함.
    
    /// toggle 정보
    var toggleOption: ToggleOptionDTO = .init(toggle: true)
    
    /// 앱 버전
//    var appVersion: String = "1.0.0"
    
    var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        return version
    }
    
    /// 문의하기 모달 띄우기
    var isModalPresented: Bool = false
    
    // MARK: - Function
    // TODO: - FireBase나 애플 로그인이나 다른 뷰 완성되어야 함.
    
    /// 토글 온오프 함수
    /// - Parameters:
    ///   - a: 토글 변경 전 상태
    ///   - b: 토글 변경 후 상태
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
