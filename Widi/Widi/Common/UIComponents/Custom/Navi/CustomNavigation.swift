//
//  CustomNavigation.swift
//  Widi
//
//  Created by Apple Coding machine on 6/2/25.
//

import SwiftUI

struct CustomNavigationIcon: View {
    
    let navigationIcon: NavigationIcon
    let action: () -> Void
    
    init(navigationIcon: NavigationIcon, action: @escaping () -> Void) {
        self.navigationIcon = navigationIcon
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            if navigationIcon.isTextButton, let title = navigationIcon.title {
                Text(title)
                    .font(.h4)
                    .foregroundStyle(navigationIcon.foregroundColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.whiteBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow1()
            } else if let image = navigationIcon.image {
                image
                    .fixedSize()
                    .padding(8)
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
