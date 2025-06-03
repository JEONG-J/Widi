//
//  ScreenSize.swift
//  Widi
//
//  Created by jeongminji on 6/3/25.
//

import Foundation
import SwiftUI

extension View {
    func getScreenSize() -> CGSize {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return windowScene.screen.bounds.size
    }
}
