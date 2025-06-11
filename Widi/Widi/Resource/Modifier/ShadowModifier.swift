//
//  Shadow.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation
import SwiftUI

struct Shadow1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(red: 0.93, green: 0.25, blue: 0.09).opacity(0.03), radius: 4, x: 0, y: 8)
            .shadow(color: Color(red: 0.55, green: 0.13, blue: 0.05).opacity(0.03), radius: 2, x: 1, y: 3)
            .shadow(color: Color(red: 0.67, green: 0.54, blue: 0.5).opacity(0.03), radius: 3, x: 0, y: 2)
    }
}

struct Glass: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(red: 0.93, green: 0.25, blue: 0.09).opacity(0.03), radius: 4, x: 0, y: 8)
            .shadow(color: Color(red: 0.55, green: 0.13, blue: 0.05).opacity(0.03), radius: 2, x: 1, y: 3)
            .foregroundStyle(.shadow(.inner(color: Color.white.opacity(0.5), radius: 2, x: 2, y: 2)))
    }
}

struct Sheet: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(red: 0.4, green: 0.4, blue: 0.4).opacity(0.02), radius: 6, x: 0, y: -4)
    }
}

struct BlurShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(red: 0.56, green: 0.56, blue: 0.58).opacity(0.05), radius: 4, x: 0, y: -14)
            .foregroundStyle(.shadow(.inner(color: Color.white.opacity(0.8), radius: 2, x: 2, y: 2)))
    }
}

extension View {
    func shadow1() -> some View {
        self.modifier(Shadow1())
    }
    
    func glass() -> some View {
        self.modifier(Glass())
    }
    
    func sheet() -> some View {
        self.modifier(Sheet())
    }
    
    func blurShadow() -> some View {
        self.modifier(BlurShadow())
    }
}
