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
    case logout
    case withdraw
    case delete
    
    var text: String {
        switch self {
        case .cancelText:
            return cancelText
        case .logout:
            return deleteText
        case .withdraw:
            return withdraw
        case .delete:
            return delete
        }
    }
    
    var color: Color {
        switch self {
        case .cancelText:
            return Color.gray40
        default:
            return Color.oragne30
        }
    }
}

enum AlertButtonType {
    case friendsDelete
    case diaryDelete
    case takeBreak
    case leave
    
    var title: String {
        switch self {
        case .friendsDelete:
            return "친구를 삭제하시겠어요?"
        case .diaryDelete:
            return "일기를 삭제하시겠어요?"
        case .takeBreak:
            return "잠시 쉬어갈까요?"
        case .leave:
            return "정말 떠나시겠어요?"
        }
    }
    
    var subtitle: String {
        switch self {
        case .friendsDelete:
            return "삭제하면 지금까지의 추억이 모두 사라져요"
        case .diaryDelete:
            return "한 번 삭제하면 다시 꺼내볼 수 없어요"
        case .takeBreak:
            return "로그아웃하면 다음에 다시 로그인해야해요"
        case .leave:
            return "여기 남긴 기억들고 위디들이 사라져요 \n이 결정은 되돌릴 수 없어요"
        }
    }
    
    var buttons: [AlertButton] {
        switch self {
        case .friendsDelete:
            return [.cancelText, .delete]
        case .diaryDelete:
            return [.cancelText, .delete]
        case .takeBreak:
            return [.cancelText, .logout]
        case .leave:
            return [.cancelText, .withdraw]
        }
    }
    
}
