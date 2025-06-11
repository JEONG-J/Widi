//
//  WidiLoginView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/9/25.
//

import SwiftUI

/// 로그인 뷰
struct WidiLoginView: View {
    
    // MARK: - Property
    var logoText: String = "Widi"
    var viewModel: LoginViewModel
    
    @State var isVisible: Bool = false
    
    
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.viewModel = .init(container: container, appFlowViewModel: appFlowViewModel)
    }
    
    var body: some View {
        ZStack {
            Color.white
            
            loginContents
        }
        .opacity(isVisible ? 1 : 0)
        .task {
            withAnimation(.easeInOut(duration: 0.5)) {
                isVisible = true
            }
        }
    }
    
    private var loginContents: some View {
        VStack {
            logoContents
            
            Spacer()
            
            Button(action: {
                    viewModel.appleLogin()
            }, label: {
                Image(.appleLoginButton)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 36)
                    .padding(.top, 10)
            })
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.bottom, 127)
        .safeAreaPadding(.top, 218)
    }
    
    private var logoContents: some View {
        VStack(spacing: 20, content: {
            Image(.loginLogo)
            
            Text(logoText)
                .font(.pretendard(type: .semibold, size: 36))
                .foregroundStyle(Color.gray80)
                .padding(.leading, 16)
                .padding(.trailing, 14)
        })
    }
}
