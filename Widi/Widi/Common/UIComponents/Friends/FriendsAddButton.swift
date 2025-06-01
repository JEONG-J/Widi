//
//  FriendsAddButton.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI

struct FriendsAddButton: View {
    
    let action: () -> Void
    let btnTitle: String = "친구 추가"
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 0, content: {
                Image(.plus)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 14, height: 14)
                
                Text(btnTitle)
                    .font(.btn)
                    .padding(.horizontal, 6)
            })
            .foregroundStyle(Color.orange30)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.whiteBlack)
                    .shadow1()
            }
        })
    }
}

#Preview {
    FriendsAddButton(action: {
        print("hello")
    })
}
