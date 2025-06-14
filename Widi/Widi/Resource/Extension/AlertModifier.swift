//
//  alertModifier.swift
//  Widi
//
//  Created by Apple Coding machine on 6/14/25.
//

import Foundation
import SwiftUI

extension View {
    func alertModifier<Content: View>(show: Bool, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.overlay {
            if show {
                CustomAlertView(content: content)
            }
        }
    }
}
