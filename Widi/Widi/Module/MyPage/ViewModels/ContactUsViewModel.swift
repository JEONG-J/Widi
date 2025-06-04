//
//  ContactUsViewModel.swift
//  Widi
//
//  Created by Miru on 2025/6/4.
//

import Foundation
import SwiftUI

/// 문의하기뷰모델
@Observable
class ContactUsViewModel {
    
    /// 이메일 텍스트
    var emailText: String = ""
    /// 문의내용 텍스트
    var contactText: String = ""
    
    /// 이메일 & 문의내용 작성 여부 확인
    var isAllComplete: Bool {
        if isEmailComplete && isContactComplete {
            return true
        }
        return false
    }
    
    /// 이메일 작성 여부 확인 & 예외처리
    var isEmailComplete: Bool {
        if emailText != "" {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: emailText)
        }
        return false
    }
    
    /// 문의내용 작성 여부 확인
    var isContactComplete: Bool {
        if contactText != "" {
            return true
        }
        return false
    }
    
    // TODO: - 문의 내용 보내기 필요
    /// 문의 내용 서버 전송
    /// - Parameters:
    ///   - eamilText: 이메일 값
    ///   - contactText: 문의 내용 값
    func complete(eamilText: String, contactText: String) {}
    
}
