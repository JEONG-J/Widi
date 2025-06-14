//
//  NavigationEnum.swift
//  Widi
//
//  Created by Apple Coding machine on 6/3/25.
//

import SwiftUI

enum NavigationIcon: Hashable {
    case gear
    case contextMenu
    case backArrow
    case closeX
    case edit
    case trash
    case complete(type: TextActionType, isEmphasized: Bool)
    
    enum TextActionType {
        case complete
        case select
    }
    
    var image: Image? {
        switch self {
        case .gear:
            return Image(.naviSetting)
        case .contextMenu:
            return Image(.naviMore)
        case .backArrow:
            return Image(.naviBack)
        case .closeX:
            return Image(.naviClose)
        case .edit:
            return Image(.naviEdit)
        case .trash:
            return Image(.naviDelete)
        case .complete:
            return nil
        }
    }
    
    var isTextButton: Bool {
        if case .complete = self { return true }
        return false
    }
    
    var title: String? {
        switch self {
        case .complete(let type, _):
            switch type {
            case .complete:
                return "완료"
            case .select:
                return "선택"
            }
        default:
            return nil
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .complete(_, let isEmphasized):
            return isEmphasized ? .orange30 : .gray40
        default:
            return .gray40
        }
    }
    
    var backgroundColor: Color {
        return Color.whiteBlack
    }
    
    var paddingValue: CGFloat {
        return 8
    }
}
