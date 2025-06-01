//
//  DiariesAddButton.swift
//  Widi
//
//  Created by jeongminji on 6/1/25.
//

import SwiftUI

struct DiariesAddButton: View {
    
    // MARK: - Properties
    
    private let action: () -> Void
    
    // MARK: - Init
    
    /// FloatingButton
    /// - Parameter action: 버튼 클릭 시 액션
    init(
        action: @escaping () -> Void
    ) {
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(.plus)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.whiteBlack)
                .padding(14)
                .background(Color.orange30)
                .clipShape(Circle())
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    DiariesAddButton(
        action: { print("클릭됨") }
    )
    .frame(width: 56)
}
