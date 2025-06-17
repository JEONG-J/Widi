//
//  FriendsAddButton.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI

/// 친구 추가 버튼 컴포넌트
struct FriendsAddButton: View {
    
    let action: () -> Void
    let btnTitle: String = "친구 추가"
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    fileprivate enum FriendAddButtonConstants {
        static let buttonRoundedRectangleCornerRadius: CGFloat = 20
        static let buttonFrame: CGFloat = 14
        static let buttonVerticalPadding: CGFloat = 8
        static let buttonTextHorizonPadding: CGFloat = 6
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(spacing: .zero, content: {
                Image(.plus)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: FriendAddButtonConstants.buttonFrame, height: FriendAddButtonConstants.buttonFrame)
                
                Text(btnTitle)
                    .font(.btn)
                    .padding(.horizontal, FriendAddButtonConstants.buttonTextHorizonPadding)
            })
            .foregroundStyle(Color.orange30)
            .padding(.vertical, FriendAddButtonConstants.buttonVerticalPadding)
            .padding(.horizontal, UIConstants.defaultHorizontalPadding)
            .background {
                RoundedRectangle(cornerRadius: FriendAddButtonConstants.buttonRoundedRectangleCornerRadius)
                    .fill(Color.whiteBlack)
                    .shadow1()
            }
        })
        .contentShape(Rectangle())
        .highPriorityGesture(DragGesture().onChanged({ _ in }))
    }
}
