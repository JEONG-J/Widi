//
//  BackgroundModifier.swift
//  Widi
//
//  Created by jeongminji on 6/4/25.
//

import Foundation
import SwiftUI

struct BackgroundShape: ViewModifier {
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let rotation: Double
    let x: CGFloat
    let y: CGFloat
    
    init(color: Color, width: CGFloat, height: CGFloat, rotation: Double, x: CGFloat, y: CGFloat) {
        self.color = color
        self.width = width
        self.height = height
        self.rotation = rotation
        self.x = x
        self.y = y
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                    Ellipse()
                        .foregroundStyle(color)
                        .frame(width: width, height: height)
                        .rotationEffect(.degrees(rotation))
                        .offset(x: x, y: y)
            )
    }
}

struct BackgroundBlur: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .foregroundStyle(Color.background.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.thinMaterial)
                    .ignoresSafeArea()
            )
    }
}

struct DetailFriendBackground: ViewModifier {
    var screenSize: CGSize
    
    init(screenSize: CGSize) {
        self.screenSize = screenSize
    }
    
    func body(content: Content) -> some View {
        
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .backgroundBlur()
            .backgroundShape(color: .backgroundYellow, width: screenSize.width * 0.25, height: screenSize.height * 0.11, rotation: 0, x: 0, y: -58)
            .backgroundShape(color: .backgroundOrange, width: screenSize.width * 0.44, height: screenSize.height * 0.22, rotation: 0, x: 0, y: -32)
            .backgroundShape(color: .backgroundPurple, width: screenSize.width * 0.63, height: screenSize.height * 0.31, rotation: 0, x: 0, y: -30)
            .backgroundShape(color: .backgroundNavy, width: screenSize.width * 0.75, height: screenSize.height * 0.38, rotation: 0, x: 2, y: -32)
            .backgroundShape(color: .backgroundBlue, width: screenSize.width * 1.06, height: screenSize.height * 0.58, rotation: 0, x: -2, y: -23)
            .backgroundShape(color: .backgroundNavy, width: screenSize.width * 0.75, height: screenSize.height * 0.33, rotation: 74,  x: screenSize.width / 2 - 293 / 2 + 62,
                             y: screenSize.height / 2 - 274 / 2 + 89)
            .backgroundShape(color: .backgroundPurple, width: screenSize.width * 0.63, height: screenSize.height * 0.28, rotation: -74,  x: -(screenSize.width / 2) + 248 / 2 - 74,
                             y: screenSize.height / 2 - 234 / 2 + 67)
            .backgroundShape(color: .backgroundBlue, width: screenSize.width * 0.96, height: screenSize.height * 0.63, rotation: -106, x: 0,  y: screenSize.height / 2 - 527 / 2 + 180)
            
    }
}

struct AddFriendBackground: ViewModifier {
    
    let screenSize: CGSize
    
    func body(content: Content) -> some View {
        content
            .backgroundBlur()
            .backgroundShape(color: Color(red: 0.95, green: 0.51, blue: 0.4), width: screenSize.width * 0.71, height: screenSize.height * 0.23, rotation: 0, x: 0, y: 120)
            .backgroundShape(color: Color(red: 0.98, green: 0.9, blue: 0.73), width: screenSize.width, height: screenSize.height * 0.48, rotation: 0, x: 0, y: 90)
    }
}

struct WriteDiaryBackground: ViewModifier {
    
    let screenSize: CGSize
    
    func body(content: Content) -> some View {
        content
            .backgroundBlur()
            .backgroundShape(color: Color(red: 0.95, green: 0.55, blue: 0.46), width: screenSize.width * 0.6, height: screenSize.height * 0.2, rotation: 0, x: 0, y: -115)
            .backgroundShape(color: Color(red: 0.63, green: 0.77, blue: 0.91), width: screenSize.width, height: screenSize.height * 0.48, rotation: 0, x: 0, y: -40)    }
}

extension View {
    /// 배경 타원 생성
    /// - Parameters:
    ///   - color: 타원 색상
    ///   - width: 타원 넓이
    ///   - height: 타원 높이
    ///   - rotation: 회전율
    ///   - x: offset 적용시킬 x 값
    ///   - y: offset 적용시킬 y 값
    /// - Returns: 타원모양 도형
    func backgroundShape(color: Color, width: CGFloat, height: CGFloat, rotation: Double, x: CGFloat, y: CGFloat) -> some View {
        self.modifier(BackgroundShape(color: color, width: width, height: height, rotation: rotation, x: x, y: y))
    }
    
    /// 타원 위에 깔 배경 블러 생성
    /// - Returns: 블러 뷰
    func backgroundBlur() -> some View {
        self.modifier(BackgroundBlur())
    }
    
    /// View에 친구 상세 배경 입힘
    /// 사용법:
    /// ` content.detailFriendViewBG()`
    /// - Returns: 친구 상세 뷰 배경
    func detailFriendViewBG() -> some View {
        self.modifier(DetailFriendBackground(screenSize: getScreenSize()))
    }
    
    /// View에 친구 추가 배경 입힘
    /// 사용법:
    /// ` content.addFriendViewBG()`
    /// - Returns: 친구 추가 뷰 배경
    func addFriendViewBG() -> some View {
        self.modifier(AddFriendBackground(screenSize: getScreenSize()))
    }
    
    /// View에 일기 작성 배경 입힘
    /// 사용법:
    /// ` content.writeDiaryViewBG()`
    /// - Returns: 일기 작성 뷰 배경
    func writeDiaryViewBG() -> some View {
        self.modifier(WriteDiaryBackground(screenSize: getScreenSize()))
    }
}
