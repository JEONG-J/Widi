//
//  DrowDownMenu.swift
//  Widi
//
//  Created by Apple Coding machine on 6/3/25.
//

import Foundation
import SwiftUI

enum DropDownMenu: CaseIterable {
    case search
    case edit
    case delete
    
    var text: String {
        switch self {
        case .search:
            return "일기 검색하기"
        case .edit:
            return "친구 수정하기"
        case .delete:
            return "친구 삭제하기"
        }
    }
    
    var textColor: Color {
        switch self {
        case .delete:
            return Color.red30
        default:
            return Color.gray50
        }
    }
    
    var textFont: Font {
        return Font.etc
    }
}
