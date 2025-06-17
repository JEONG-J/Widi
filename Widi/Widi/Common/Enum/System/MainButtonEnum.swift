//
//  MainButtonEnum.swift
//  Widi
//
//  Created by jeongminji on 6/1/25.
//

import SwiftUI

/// 메인 버튼의 유형(다음, 건너뛰기)에 따라 텍스트, 배경색, 글자색을 정의한 열거형
enum MainButtonType {
    case next(isDisabled: Bool)
    case skip
    
    var title: String {
        switch self {
        case .next:
            return "다음으로"
        case .skip:
            return "건너뛰기"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .next(let isDisabled):
            return isDisabled ? .gray20 : .orange30
        case .skip:
            return .white.opacity(0.7)
        }
    }

    var textColor: Color {
        switch self {
        case .next(let isDisabled):
            return isDisabled ? .gray40 : .white
        case .skip:
            return .orange30
        }
    }
}
