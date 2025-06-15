//
//  AddFriendView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import SwiftUI

/// 친구 추가 뷰
struct AddFriendView: View {
    
    // MARK: - Property
    @State var viewModel: AddFriendsViewModel
    @EnvironmentObject var container: DIContainer
    @FocusState var isFocused: AddFriendsField?
    
    // MARK: - Constants
    
    fileprivate enum AddFriendConstants {
        // Layout spacing
        static let contentsTopPadding: CGFloat = 52
        static let textFieldGroupSpacing: CGFloat = 32
        static let hStackButtonSpacing: CGFloat = 10
        
        // Padding
        static let navigationBottomPadding: CGFloat = 12
        static let mainButtonBottomPadding: CGFloat = 16
        static let horizontalSafeAreaPadding: CGFloat = 16
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.clear
                .addFriendViewBG()
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
            VStack(alignment: .center, content: {
                middleContents()
                
                Spacer()
                
                bottomMainButton()
            })
        }
        .navigationBarBackButtonHidden(true)
        .task {
            isFocused = (viewModel.currentPage == 1) ? .name : .birthDay
        }
        .onChange(of: viewModel.currentPage, { old, new in
            isFocused = (new == 1) ? .name : .birthDay
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading, content: {
                if viewModel.currentPage == 1 {
                    CustomNavigationIcon(navigationIcon: .closeX, action: {
                        container.navigationRouter.pop()
                    })
                } else {
                    CustomNavigationIcon(navigationIcon: .backArrow, action: {
                        viewModel.currentPage -= 1
                    })
                }
            })
            
            if viewModel.currentPage != 1 {
                ToolbarItem(placement: .topBarTrailing) {
                    CustomNavigationIcon(navigationIcon: .closeX, action: {
                        container.navigationRouter.pop()
                    })
                }
            }
        })
    }
    
    // MARK: - Function
    
    /// 텍스트 필드 분기처리
    /// - Returns: 분기로 처리된 텍스트 필드 뷰
    @ViewBuilder
    private func middleContents() -> some View {
        Group {
            switch viewModel.currentPage {
            case 1:
                makeTextField(for: .name, $viewModel.friendsName, onAction: {
                    viewModel.currentPage += 1
                })
            default:
                makeTextField(for: .birthDay, $viewModel.friendsBirthDay, onAction: {})
            }
        }
        .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
        .padding(.top, AddFriendConstants.contentsTopPadding)
    }
    
    /// 메인버튼 분기 처리
    /// - Returns: 페이지에 맞도록 메인 버튼 분기처리
    @ViewBuilder
    private func bottomMainButton() -> some View {
        Group {
            switch viewModel.currentPage {
            case 1:
                CustomMainButton(type: .next(isDisabled: viewModel.friendsName.isEmpty), action: {
                    viewModel.currentPage += 1
                })
                .disabled(viewModel.friendsName.isEmpty)
                
            default:
                secondPageMainButton()
            }
        }
        .padding(.bottom, AddFriendConstants.mainButtonBottomPadding)
        .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
    }
    
    /// 두 번째 페이지 텍스트 필드 그룹
    /// - Returns: 두 번째 페이지 텍스트 필드 뷰 반환
    @ViewBuilder
    private func secondPageMainButton() -> some View {
        let pushAction = {
            viewModel.navigationPush()
        }
        
        HStack(alignment: .center, spacing: AddFriendConstants.hStackButtonSpacing, content: {
            CustomMainButton(type: .skip, action: pushAction)
            
            CustomMainButton(type: .next(isDisabled: viewModel.friendsBirthDay.isEmpty), action: pushAction)
                .disabled(viewModel.friendsBirthDay.isEmpty)
        })
    }
    
    /// 친구 정보 입력 텍스트 필드 생성 함수
    /// - Parameter field: 정보 입력 타입 설정
    /// - Returns: 뷰 타입 반환
    @ViewBuilder
    private func makeTextField(for field: AddFriendsField, _ value: Binding<String>, onAction: @escaping () -> Void) -> some View {
        VStack(alignment: .center, spacing: AddFriendConstants.textFieldGroupSpacing, content: {
            Text(field.title)
                .font(.h4)
                .foregroundStyle(Color.gray50)
            
            TextField(field.placeholder, text: value, prompt: makePlaceholder(text: field.placeholder) as? Text)
                .font(.h1)
                .foregroundStyle(Color.gray80)
                .multilineTextAlignment(.center)
                .keyboardType(field == .birthDay ? .numberPad : .default)
                .onChange(of: value.wrappedValue, { old, new in
                    if field == .birthDay {
                        value.wrappedValue = ConvertDataFormat.shared.formatBirthdayInput(new)
                    }
                })
                .onSubmit({onAction()})
                .submitLabel(.next)
                .focused($isFocused, equals: field == .name ? .name : .birthDay)
        })
    }
    
    /// 텍스트 필드 내부 placeholder
    /// - Parameter text: 텍스트 필드 placeholder 값
    /// - Returns: Text 반환
    @ViewBuilder
    private func makePlaceholder(text: String) -> some View {
        Text(text)
            .font(.h1)
            .foregroundStyle(Color.gray30)
    }
}


#Preview {
    AddFriendView(container: DIContainer())
        .environmentObject(DIContainer())
}
