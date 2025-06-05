//
//  CustomBackgroundShape.swift
//  Widi
//
//  Created by jeongminji on 6/4/25.
//

import SwiftUI

struct CustomBackgroundShape: View {
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let rotation: Double
    let x: CGFloat
    let y: CGFloat

    var body: some View {
        Ellipse()
            .foregroundStyle(color)
            .frame(width: width, height: height)
            .rotationEffect(Angle(degrees: rotation))
            .offset(x: x, y: y)
    }
}

#Preview {
    CustomBackgroundShape(
        color: .backgroundBlue,
        width: 420,
        height: 484,
        rotation: 70,
        x: -2,
        y: -23
    )
}
