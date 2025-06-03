//
//  CustomActionSheet.swift
//  Widi
//
//  Created by jeongminji on 6/4/25.
//

import SwiftUI

struct ActionSheetButton {
    let title: String
    var role: ButtonRole? = .none
    let action: () -> Void
}

struct CustomActionSheet: View {
    private let buttons: [ActionSheetButton]
    
    /// CustomActionSheet
    /// - Parameter buttons: ActionSheetButton 리스트 (title, role, action)
    init(buttons: [ActionSheetButton]) {
        self.buttons = buttons
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(buttons.indices, id: \.self) { index in
                Button(
                    action: {
                        buttons[index].action()
                    }
                ) {
                    Text(buttons[index].title)
                        .font(.etc)
                        .foregroundColor(buttons[index].role == .destructive ? .red30 : .gray50)
                        .frame(height: 39)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                }
                
                if index < buttons.count - 1 {
                    Divider()
                        .background(Color.gray20)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 0)
        .background(Color.whiteBlack)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .shadow1()
    }
}

#Preview {
    let action: [ActionSheetButton] = [
        ActionSheetButton(
            title: "일기 검색하기",
            action: {print("일기 검색")}
        ),
        ActionSheetButton(
            title: "친구 수정하기",
            action: {print("친구 수정")}
        ),
        ActionSheetButton(
            title: "친구 삭제하기",
            role: .destructive,
            action: {print("친구 삭제")}
        )
    ]
    
    CustomActionSheet(buttons: action)
        .frame(width: 200)
}
