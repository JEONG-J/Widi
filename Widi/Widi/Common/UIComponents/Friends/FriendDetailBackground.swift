//
//  FriendDetailBackground.swift
//  Widi
//
//  Created by jeongminji on 6/3/25.
//

import SwiftUI

struct FriendDetailBackground: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundShape(color: .backgroundBlue, width: 420, height: 484, cornerRadius: 484, rotation: 0, x: -2, y: -23)
                backgroundShape(color: .backgroundBlue, width: 378, height: 527, cornerRadius: 527, rotation: -106, x: 0, y: geo.size.height / 2 - 527 / 2 + 180)
                backgroundShape(color: .backgroundNavy, width: 293, height: 274, cornerRadius: 293, rotation: 74, x: geo.size.width / 2 - 293 / 2 + 62, y: geo.size.height / 2 - 274 / 2 + 89)
                backgroundShape(color: .backgroundPurple, width: 248, height: 234, cornerRadius: 258, rotation: -74, x: -(geo.size.width / 2) + 248 / 2 - 74, y: geo.size.height / 2 - 234 / 2 + 53)
                backgroundShape(color: .backgroundNavy, width: 293, height: 320, cornerRadius: 320, rotation: 0, x: 2, y: -32)
                backgroundShape(color: .backgroundPurple, width: 248, height: 258, cornerRadius: 258, rotation: 0, x: 0, y: -30)
                backgroundShape(color: .backgroundOrange, width: 174, height: 186, cornerRadius: 186, rotation: 0, x: 0, y: -32)
                backgroundShape(color: .backgroundYellow, width: 98, height: 97, cornerRadius: 97, rotation: 0, x: 0, y: -58)
                
                Rectangle()
                    .foregroundColor(Color.background.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.thinMaterial)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func backgroundShape(
        color: Color,
        width: CGFloat,
        height: CGFloat,
        cornerRadius: CGFloat,
        rotation: Double,
        x: CGFloat,
        y: CGFloat
    ) -> some View {
        Rectangle()
            .foregroundColor(color)
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
            .rotationEffect(Angle(degrees: rotation))
            .offset(x: x, y: y)
    }
}

#Preview {
    FriendDetailBackground()
}
