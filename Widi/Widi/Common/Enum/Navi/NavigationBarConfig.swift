//
//  NavigationBarConfig.swift
//  Widi
//
//  Created by Apple Coding machine on 6/3/25.
//

import Foundation

enum NavigationBarConfig: Hashable {
    case gearOnly // 톱니바퀴만
    case backAndContextMenu // 완쪽 화살표, 오른쪽 점 세개 버튼
    case closeOnly // 왼쪽 x 버튼만
    case backOnly // 왼쪽 화살표만
    case closeAndComplete(type: NavigationIcon.TextActionType, isEmphasized: Bool) // 왼쪽 x 닫기 버튼 오른쪽 완료 텍스트 버튼
    case backTitleAndEditTrash(title: String) // 왼쪽 화살표 가운데 타이틀 오른쪽 수정버튼 및 쓰레기 버튼
    case backAndComplete(isEmphasized: Bool) // 왼쪽 화살표, 오른쪽 완료 텍스트 버튼
    case backAndTitleComplete(title: String, isEmphasized: Bool) // 왼쪽 화살표, 오른쪽 완료 텍스트 버튼
    case closeAndTrash // 왼쪽 x 닫기, 오른쪽 쓰레기
    case backAndClose // 왼쪽 화살표, 오른쪽 x 버튼
    
    /// 왼쪽 아이콘 모음
    var left: [NavigationIcon] {
        switch self {
        case .gearOnly:
            return []
        case .closeOnly, .closeAndComplete, .closeAndTrash:
            return [.closeX]
        case .backOnly, .backAndContextMenu, .backTitleAndEditTrash, .backAndComplete, .backAndClose, .backAndTitleComplete:
            return [.backArrow]
        }
    }
    
    /// 오른쪽 아이콘
    var right: [NavigationIcon] {
        switch self {
        case .gearOnly:
            return [.gear]
        case .backAndContextMenu:
            return [.contextMenu]
        case .closeOnly:
            return []
        case .backOnly:
            return []
        case .closeAndComplete(let type, let isEmphasized):
            return [.complete(type: type, isEmphasized: isEmphasized)]
        case .backTitleAndEditTrash:
            return [.edit, .trash]
        case .backAndComplete(let isEmphasized), .backAndTitleComplete(_, let isEmphasized):
            return [.complete(type: .complete, isEmphasized: isEmphasized)]
        case .closeAndTrash:
            return [.trash]
        case .backAndClose:
            return [.closeX]
        }
    }
    
    /// 타이틀
    var center: String? {
        switch self {
        case .backTitleAndEditTrash(let title), .backAndTitleComplete(let title, _):
            return title
        default:
            return nil
        }
    }
}
