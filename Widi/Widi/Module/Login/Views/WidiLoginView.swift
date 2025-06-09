//
//  WidiLoginView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/9/25.
//

import SwiftUI

struct WidiLoginView: View {
    
    var viewModel: LoginViewModel
    
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    var body: some View {
        ZStack {
            Color.white
            
            loginContents
        }
    }
    
    private var loginContents: some View {
        VStack {
            
            Text("Logo")
                .font(.h1)
                .foregroundStyle(Color.black)
            
            Spacer()
            
            Button(action: {
                viewModel.appleLogin()
            }, label: {
                Image(.appleLoginButton)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 36)
            })
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.bottom, 127)
        .safeAreaPadding(.top, 218)
    }
}

#Preview {
    WidiLoginView(container: DIContainer())
}
