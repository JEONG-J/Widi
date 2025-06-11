//
//  DiaryContainerModifier.swift
//  Widi
//
//  Created by Apple Coding machine on 6/11/25.
//

import Foundation
import SwiftUI

struct DiaryContainerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.top, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background {
                UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                    .fill(Color.whiteBlack)
            }
    }
}

extension View {
    func diaryContainerStyle() -> some View {
        self.modifier(DiaryContainerModifier())
    }
}
