//
//  AddFriendView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import SwiftUI

struct AddFriendView: View {
    
    @Bindable var viewModel: AddFriendsViewModel = .init()
    @EnvironmentObject var container: DIContainer
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 52, content: {
            topNavigation(value: viewModel.currentPage)
            
            returnContents()
            
            Spacer()
            
            returnMainButton()
        })
        .safeAreaPadding(.horizontal, 16)
        .task {
            UIApplication.shared.hideKeyboard()
        }
    }
    
    // MARK: - Function
    
    @ViewBuilder
    private func returnContents() -> some View {
        switch viewModel.currentPage {
        case 1:
            makeTextField(for: .name, $viewModel.friendsName)
        default:
            makeTextField(for: .birthDay, $viewModel.friendsBirthDay)
        }
    }
    
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
    }
    
    @ViewBuilder
    private func secondPageMainButton() -> some View {
        HStack(alignment: .center, spacing: 10, content: {
            CustomMainButton(type: .skip, action: {
                viewModel.currentPage += 1
            })
            
            CustomMainButton(type: .next(isDisabled: viewModel.friendsBirthDay.isEmpty), action: {
                viewModel.currentPage += 1
            })
            .disabled(viewModel.friendsBirthDay.isEmpty)
        })
    }
    
    /// 친구 정보 입력 텍스트 필드 생성 함수
    /// - Parameter field: 정보 입력 타입 설정
    /// - Returns: 뷰 타입 반환
    @ViewBuilder
    private func makeTextField(for field: AddFriendsField, _ value: Binding<String>) -> some View {
        VStack(alignment: .center, spacing: 32, content: {
            Text(field.title)
                .font(.h4)
                .foregroundStyle(Color.gray50)
            
            TextField("", text: value, prompt: makePlaceholder(text: field.placeholder) as? Text)
                .font(.h1)
                .foregroundStyle(Color.gray80)
                .multilineTextAlignment(.center)
                .keyboardType(field == .birthDay ? .numberPad : .default)
                .onChange(of: value.wrappedValue, { old, new in
                    if field == .birthDay {
                        value.wrappedValue = formatBirthdayInput(new)
                    }
                })
                .focused($isFocused)
        })
        .task {
            isFocused = true
        }
    }
    
    /// 텍스트 필드 내부 placeholder
    /// - Parameter text: 텍스트 필드 placeholder 값
    /// - Returns: Text 반환
    @ViewBuilder
    private func makePlaceholder(text: String) -> some View {
        if !isFocused {
            Text(text)
                .font(.h1)
                .foregroundStyle(Color.gray30)
        }
    }
    
    /// 상단 네비게이션 분기 처리
    /// - Parameter value: 현재 페이지 입력
    /// - Returns: 네비게이션 뷰 반환
    @ViewBuilder
    private func topNavigation(value: Int) -> some View {
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
    
    private func formatBirthdayInput(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }

        var result = ""
        
        if digits.count > 0 {
            result += String(digits.prefix(2))
        }
        if digits.count > 2 {
            result += " / "
            result += String(digits.dropFirst(2).prefix(2))
        }
        
        return result
    }
}

#Preview {
    AddFriendView(viewModel: .init())
        .environmentObject(DIContainer())
}
