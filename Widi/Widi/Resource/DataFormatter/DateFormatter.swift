//
//  DateFormatter.swift
//  Widi
//
//  Created by Miru on 2025/6/5.
//

import Foundation

class ConvertDataFormat {
    static let shared = ConvertDataFormat()
    
    /// 생일 날짜 자동 입력 함수
    /// - Parameter input: 생일 숫자 입력
    /// - Returns: / 로 분리된 날짜 데이터 반환
    func formatBirthdayInput(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }

        var result = ""
        
        if digits.count > 0 {
            result += String(digits.prefix(2))
        }
        if digits.count > 2 {
            result += " / "
            result += String(digits.dropFirst(2).prefix(2))
        }
        
        return result
    }
}
