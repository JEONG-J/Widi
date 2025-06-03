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
    var appVersion: String = "1.0.0"
    
    /// 문의하기 모달 띄우기
    var isModalPresented: Bool = false
    
    // MARK: - Function
    
    /// 토글 온오프 함수
    /// - Parameters:
    ///   - a: 토글 변경 전 상태
    ///   - b: 토글 변경 후 상태
    func toggleOnOff(a:Bool, b:Bool) -> Void {}
    
    /// 로그아웃 버튼 함수
    func logOutAction () -> Void {}
    /// 탈퇴하기 버튼 함수
    func deleteAccountAction () -> Void {}
    
}
