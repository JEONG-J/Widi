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
    
    /// 이메일 & 문의내용 작성 완료 여부
    var isAllComplete: Bool {
        if isEmailComplete && isContactComplete {
            return true
        }
        return false
    }
    
    /// 이메일 작성 완료 여부
    var isEmailComplete: Bool = true
    
    /// 문의내용 작성 여부
    var isContactComplete: Bool {
        if contactText != "" {
            return true
        }
        return false
    }
    
    var isContactFocusedOnce: Bool = false
    
    func checkEmailFormat() {
        let emailRegex = #".+@.*(com|net|kr|ac|go|ne|nm|or|re|mil|gov|org|edu)"#
        self.isEmailComplete = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: emailText)
    }
    
    // TODO: - 문의 내용 보내기 필요
    /// 문의 내용 서버 전송
    func complete() {
    }
    
}
