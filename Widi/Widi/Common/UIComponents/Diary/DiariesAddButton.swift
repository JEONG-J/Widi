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
        .shadow(color: Color(red: 0.63, green: 0.77, blue: 0.91).opacity(0.2), radius: 8, x: 0, y: 8)
        .shadow(color: Color(red: 0.17, green: 0.27, blue: 0.48).opacity(0.08), radius: 1, x: 0, y: 2)
    }
}

#Preview {
    DiariesAddButton(
        action: { print("클릭됨") }
    )
    .frame(width: 56)
}
