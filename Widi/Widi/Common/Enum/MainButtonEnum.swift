//
//  MainButtonEnum.swift
//  Widi
//
//  Created by jeongminji on 6/1/25.
//

import SwiftUI

enum MainButtonBasicText {
    case save
    case next
    
    var text: String {
        switch self {
        case .save: return "저장하기"
        case .next: return "다음으로"
        }
    }
}

enum MainButtonType {
    case basic(type: MainButtonBasicText, isDisabled: Bool)
    case skip
    
    var title: String {
        switch self {
        case .basic(let type, _):
            return type.text
        case .skip:
            return "건너뛰기"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .basic(_, let isDisabled):
            return isDisabled ? .gray20 : .orange30
        case .skip:
            return .white.opacity(0.7)
        }
    }

    var textColor: Color {
        switch self {
        case .basic(_, let isDisabled):
            return isDisabled ? .gray40 : .white
        case .skip:
            return .orange30
        }
    }
}
