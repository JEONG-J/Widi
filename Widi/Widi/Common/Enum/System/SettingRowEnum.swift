//
//  SettingRowEnum.swift
//  Widi
//
//  Created by jeongminji on 6/2/25.
//

import SwiftUI

/// 설정 화면의 각 항목 유형(토글, 네비게이션, 버전 정보)을 정의한 열거형
enum SettingRowType {
    case toggle(
        isOn: Binding<ToggleOptionDTO>,
        description: String? = nil,
        onToggleChanged: ((Bool, Bool) -> Void)? = nil
    )
    case navigation
    case version(text: String)
    
    var title: String {
        switch self {
        case .toggle:
            return "푸시알림"
        case .navigation:
            return "문의하기"
        case .version:
            return "앱 관리"
        }
    }
    
    var description: String? {
        switch self {
        case .toggle(_, let description, _):
            return description
        case .navigation, .version:
            return nil
        }
    }
    
    var onToggleChanged: ((Bool, Bool) -> Void)? {
        switch self {
        case .toggle(_, _, let onToggleChanged):
            return onToggleChanged
        case .navigation, .version:
            return nil
        }
    }
}
