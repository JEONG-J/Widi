//
//  InfoAreatType.swift
//  Widi
//
//  Created by Apple Coding machine on 6/10/25.
//

import Foundation
import SwiftUI

enum InfoAreaType {
    case birthday
    case name
    
    var title: String {
        switch self {
        case .birthday:
            return "생일"
        case .name:
            return "이름"
        }
    }
    
    var placeholder: String {
        switch self {
        case .birthday:
            "mm / dd"
        case .name:
            "이름"
        }
    }
    
    func guideText(text: String) -> String {
        switch self {
        case .birthday:
            return ""
        case .name:
            return "\(text.count) / 10"
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .birthday:
            return .numberPad
        case .name:
            return .default
        }
    }
}
