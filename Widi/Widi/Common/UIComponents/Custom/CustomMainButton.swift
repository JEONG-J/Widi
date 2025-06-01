//
//  CustomMainButton.swift
//  Widi
//
//  Created by jeongminji on 5/30/25.
//

import SwiftUI

struct CustomMainButton: View {

    // MARK: - Properties

    private let type: MainButtonType
    private let action: () -> Void

    // MARK: - Init
    
    /// CustomMainButton
    /// - Parameters:
    ///   - type: basic(저장하기, 다음으로), skip(건너뛰기) 중 택 1
    ///   - action: 버튼 클릭 시 액션
    init(
        type: MainButtonType,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(type.title)
                .foregroundStyle(type.textColor)
                .font(.h2)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(type.backgroundColor)
                .cornerRadius(26)
                .shadow1()
        }
    }
}

#Preview {
    CustomMainButton(
        type: .basic(
            type: .next,
            isDisabled: true
        ),
        action: { print("1번 버튼 클릭됨") }
    )
    .disabled(true)
    .frame(width: .infinity)
    .padding(.horizontal, 16)
    
    CustomMainButton(
        type: .basic(
            type: .next,
            isDisabled: false
        ),
        action: { print("2번 버튼 클릭됨") }
    )
    .frame(width: .infinity)
    .padding(.horizontal, 16)
    
    HStack(spacing: 10) {
        CustomMainButton(
            type: .skip,
            action: { print("건너뛰기 클릭됨") }
        )
        .frame(width: .infinity)
        
        CustomMainButton(
            type: .basic(
                type: .next,
                isDisabled: true
            ),
            action: { print("3번 버튼 클릭됨") }
        )
        .disabled(true)
        .frame(width: .infinity)
    }
    .padding(.horizontal, 16)
    
    HStack(spacing: 10) {
        CustomMainButton(
            type: .skip,
            action: { print("건너뛰기 클릭됨") }
        )
        .frame(width: .infinity)
        
        CustomMainButton(
            type: .basic(
                type: .next,
                isDisabled: false
            ),
            action: { print("4번 버튼 클릭됨") }
        )
        .frame(width: .infinity)
    }
    .padding(.horizontal, 16)
}
