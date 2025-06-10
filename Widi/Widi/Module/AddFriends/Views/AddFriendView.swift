//
//  AddFriendView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import SwiftUI

struct AddFriendView: View {
    
    @Bindable var viewModel: AddFriendsViewModel
    @EnvironmentObject var container: DIContainer
    @FocusState var isFocused: AddFriendsField?
    
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 52, content: {
            topNavigation(value: viewModel.currentPage)
                .padding(.bottom, 12)
            
            returnContents()
            
            Spacer()
            
            returnMainButton()
        })
        .addFriendViewBG()
        .navigationBarBackButtonHidden(true)
        .task {
            UIApplication.shared.hideKeyboard()
            isFocused = (viewModel.currentPage == 1) ? .name : .birthDay
        }
        .onChange(of: viewModel.currentPage, { old, new in
            isFocused = (new == 1) ? .name : .birthDay
        })
    }
    
    // MARK: - Function
    
    /// 텍스트 필드 분기처리
    /// - Returns: 분기로 처리된 텍스트 필드 뷰
    @ViewBuilder
    private func returnContents() -> some View {
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
        .safeAreaPadding(.horizontal, 16)
    }
    
    /// 메인버튼 분기 처리
    /// - Returns: 페이지에 맞도록 메인 버튼 분기처리
    @ViewBuilder
    private func returnMainButton() -> some View {
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
        .padding(.bottom, 16)
        .safeAreaPadding(.horizontal, 16)
    }
    
    /// 두 번째 페이지 텍스트 필드 그룹
    /// - Returns: 두 번째 페이지 텍스트 필드 뷰 반환
    @ViewBuilder
    private func secondPageMainButton() -> some View {
        let pushAction = {
            viewModel.navigationPush()
        }
        
        HStack(alignment: .center, spacing: 10, content: {
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
        VStack(alignment: .center, spacing: 32, content: {
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
    
    /// 상단 네비게이션 분기 처리
    /// - Parameter value: 현재 페이지 입력
    /// - Returns: 네비게이션 뷰 반환
    @ViewBuilder
    private func topNavigation(value: Int) -> some View {
        Group {
            switch value {
            case 1:
                CustomNavigation(config: .closeOnly, leftAction: { icon in
                    switch icon {
                    case .closeX:
                        container.navigationRouter.pop()
                    default:
                        break
                    }
                }, rightAction: { _ in })
                
            default:
                CustomNavigation(config: .backAndClose, leftAction: { icon in
                    switch icon {
                    case .backArrow:
                        viewModel.currentPage -= 1
                    default:
                        break
                    }
                }, rightAction: { icon in
                    switch icon {
                    case .closeX:
                        container.navigationRouter.pop()
                    default:
                        break
                    }
                })
            }
        }
        .safeAreaPadding(.horizontal, 16)
    }
}
