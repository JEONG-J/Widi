//
//  TestProtocol.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation

/// 알림 버튼에 공통으로 사용되는 텍스트를 정의한 프로토콜
protocol ButtonTextProtocol {
    var returnTo: String { get }
    var continuation: String { get }
    
    var delete: String { get }
    var withdraw: String { get }
    var logout: String { get }
    var exit: String { get }
}

extension ButtonTextProtocol {
    var returnTo: String { "돌아가기" }
    var continuation: String { "이어쓰기" }
    
    var delete: String { "삭제하기" }
    var withdraw: String { "탈퇴하기" }
    var logout: String { "로그아웃" }
    var exit: String { "나가기" }
}
