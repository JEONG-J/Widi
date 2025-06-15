//
//  CustomNavigation.swift
//  Widi
//
//  Created by Apple Coding machine on 6/2/25.
//

import SwiftUI

/// 커스텀 네비게이션 바 버튼 컴포넌트
struct CustomNavigationIcon: View {
    
    // MARK: - Property
    let navigationIcon: NavigationIcon
    let action: () -> Void
    
    // MARK: - Init
    init(navigationIcon: NavigationIcon, action: @escaping () -> Void) {
        self.navigationIcon = navigationIcon
        self.action = action
    }
    
    // MARK: - Constants
    private enum CustomNavigationIconConstants {
        // Text 버튼
        static let textFont: Font = .h4
        static let textHorizontalPadding: CGFloat = 20
        static let textVerticalPadding: CGFloat = 10
        static let textCornerRadius: CGFloat = 20
        
        // 이미지 버튼
        static let imagePadding: CGFloat = 8
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            if navigationIcon.isTextButton, let title = navigationIcon.title {
                Text(title)
                    .font(.h4)
                    .foregroundStyle(navigationIcon.foregroundColor)
                    .padding(.horizontal, CustomNavigationIconConstants.textHorizontalPadding)
                    .padding(.vertical, CustomNavigationIconConstants.textVerticalPadding)
                    .background(Color.whiteBlack)
                    .clipShape(RoundedRectangle(cornerRadius: CustomNavigationIconConstants.textCornerRadius))
                    .shadow1()
            } else if let image = navigationIcon.image {
                image
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray60)
                    .fixedSize()
                    .padding(CustomNavigationIconConstants.imagePadding)
                    .background(Color.whiteBlack)
                    .clipShape(Circle())
                    .shadow1()
            }
        })
    }
}

#Preview {
    CustomNavigationIcon(navigationIcon: .complete(type: .select, isEmphasized: true), action: {
        print("hello")
    })
}
