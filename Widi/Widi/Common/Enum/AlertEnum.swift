//
//  TestEnum.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation
import SwiftUI

enum AlertButton: ButtonTextProtocol, CaseIterable {
    case cancelText
    case deleteText
    
    var text: String {
        switch self {
        case .cancelText:
            return cancelText
        case .deleteText:
            return deleteText
        }
    }
    
    var color: Color {
        switch self {
        case .cancelText:
            return Color.gray40
        case .deleteText:
            return Color.oragne30
        }
    }
}

enum AlertTopText: CaseIterable {
    case title
    case subTitle
    
    var text: String {
        switch self {
        case .title:
            return "친구를 삭제하시겠어요?"
        case .subTitle:
            return "삭제하면 지금까지의 추억이 모두 사라져요"
        }
    }
    
    var color: Color {
        switch self {
        case .title:
            return Color.black
        case .subTitle:
            return Color.gray40
        }
    }
    
    var font: Font {
        switch self {
        case .title:
            return Font.h3
        case .subTitle:
            return Font.b2
        }
    }
}
