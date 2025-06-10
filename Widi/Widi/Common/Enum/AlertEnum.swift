//
//  TestEnum.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation
import SwiftUI

enum AlertButton: ButtonTextProtocol, CaseIterable {
    
    case returnTo
    case continuation
    
    case withdraw
    case delete
    case logout
    case exit
    
    var text: String {
        switch self {
        case .returnTo:
            return returnTo
        case .continuation:
            return continuation
        case .withdraw:
            return withdraw
        case .delete:
            return delete
        case .logout:
            return logout
        case .exit:
            return exit
        }
    }
    
    var color: Color {
        switch self {
        case .continuation, .returnTo:
            return Color.gray40
        default:
            return Color.orange30
        }
    }
}

enum AlertButtonType {
    case friendsDelete
    case diaryDelete
    
    case stopEdit
    case stopDiary
    case stopDiaryFirst
    
    case logoutUser
    case withdrawUser
    
    var title: String {
        switch self {
        case .friendsDelete:
            return "친구를 삭제하시겠어요?"
        case .diaryDelete:
            return "일기를 삭제하시겠어요?"
        case .stopEdit:
            return "수정을 멈추시겠어요?"
        case .stopDiary, .stopDiaryFirst:
            return "일기를 남기지 않고 나가시겠어요?"
        case .logoutUser:
            return "잠시 쉬어갈까요?"
        case .withdrawUser:
            return "정말 떠나시겠어요?"
        }
    }
    
    var subtitle: String {
        switch self {
        case .friendsDelete:
            return "삭제하면 지금까지의 추억이 모두 사라져요"
        case .diaryDelete:
            return "한 번 삭제하면 다시 꺼내볼 수 없어요"
        case .stopEdit:
            return "고쳐 쓴 일기는 저장되지 않아요"
        case .stopDiary:
            return "작성 중인 내용은 저장되지 않아요"
        case .stopDiaryFirst:
            return "이전으로 돌아가면 작성한 친구 정보는 없어져요"
        case .logoutUser:
            return "로그아웃하면 다음에 다시 로그인이 필요해요"
        case .withdrawUser:
            return "여기 남긴 기억들과 위디들이 사라져요. 이 결정은 되돌릴 수 없어요"
        }
    }
    
    var buttons: [AlertButton] {
        switch self {
        case .friendsDelete, .diaryDelete:
            return [.returnTo, .delete]
        case .stopEdit, .stopDiary, .stopDiaryFirst:
            return [.continuation, .exit]
        case .logoutUser:
            return [.returnTo, .logout]
        case .withdrawUser:
            return [.returnTo, .withdraw]
        }
    }
}
