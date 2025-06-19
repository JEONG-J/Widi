//
//  DateFormatter.swift
//  Widi
//
//  Created by Miru on 2025/6/5.
//

import Foundation

/// 날짜 string 변환기
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
    
    /// 현재 날짜 데이터 가져오기
    /// - Returns: 오늘 날짜 년 월 일 가져오기
    func simpleDateString(from date: Date) -> String {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date) % 100
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return "\(year)년 \(month)월 \(day)일"
    }
    
    /// "yy년 M월 d일" 형식의 문자열을 Date로 변환
    /// - Parameter string: "25년 6월 19일" 형식의 문자열
    /// - Returns: Date 객체 (변환 실패 시 nil)
    func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy년 M월 d일"
        return formatter.date(from: string)
    }
}
