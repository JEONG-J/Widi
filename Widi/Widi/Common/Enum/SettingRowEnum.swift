//
//  SettingRowEnum.swift
//  Widi
//
//  Created by jeongminji on 6/2/25.
//

import SwiftUI

enum SettingRowType {
    case toggle(isOn: Binding<ToggleOptionDTO>, description: String? = nil)
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
        case .toggle(_, let description):
            return description
        case .navigation, .version:
            return nil
        }
    }
}
