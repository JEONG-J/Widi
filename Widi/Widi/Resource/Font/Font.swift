//
//  Font.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation
import SwiftUI

extension Font {
    
    // MARK: - Pretendard Enum
    enum Pretendard {
        case semibold
        case medium
        case regular
        
        var value: String {
            switch self {
            case .semibold:
                return "PretendardVariable-SemiBold"
            case .medium:
                return "PretendardVariable-Medium"
            case .regular:
                return "PretendardVariable-Regular"
            }
        }
    }
    
    static func pretendard(type: Pretendard, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // MARK: - Heading
    static var h1: Font {
        return .pretendard(type: .semibold, size: 28)
    }
    
    static var h2: Font {
        return .pretendard(type: .semibold, size: 20)
    }
    
    static var h3: Font {
        return .pretendard(type: .semibold, size: 18)
    }
    
    static var h4: Font {
        return .pretendard(type: .semibold, size: 16)
    }
    
    // MARK: - Body
    static var b1: Font {
        return .pretendard(type: .regular, size: 16)
    }
    
    static var b2: Font {
        return .pretendard(type: .regular, size: 14)
    }
    
    // MARK: - Button
    static var btn: Font {
        return .pretendard(type: .semibold, size: 15)
    }
    
    // MARK: - Caption
    static var cap1: Font {
        return .pretendard(type: .semibold, size: 14)
    }
    
    static var cap2: Font {
        return .pretendard(type: .regular, size: 14)
    }
    
    // MARK: - Etc
    static var etc: Font {
        return .pretendard(type: .medium, size: 18)
    }
}
