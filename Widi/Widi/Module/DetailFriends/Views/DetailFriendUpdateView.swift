//
//  DetailFriendUpdatedView.swift
//  Widi
//
//  Created by Miru on 2025/6/5.
//

import SwiftUI

/// 친구 수정 뷰
struct DetailFriendUpdateView: View {

    @Binding var showFriendEdit: Bool
    @Bindable var viewModel: DetailFriendUpdateViewModel
    
    init(
        container: DIContainer,
        showFriendEdit: Binding<Bool>,
        friendResponse: FriendResponse
    ) {
        self._viewModel = Bindable(wrappedValue: DetailFriendUpdateViewModel(container: container, friendResponse: friendResponse))
        self._showFriendEdit = showFriendEdit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DetailFriendUpdate.detailFriendSpacing) {
            topController
            friendDetailArea
            
            Spacer()
        }
        .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
        .safeAreaPadding(.top, DetailFriendUpdate.detailFriendTopPadding)
        .task {
            UIApplication.shared.hideKeyboard()
        }
        .background(Color.whiteBlack)
    }
    
    /// 상단 네비게이션 컨트롤러
    private var topController: some View {
        HStack {
            Button {
                showFriendEdit.toggle()
            } label: {
                NavigationIcon.closeX.image
                .padding(NavigationIcon.closeX.paddingValue)
            }
            
            Spacer()
            
            Button {
                Task {
                    await viewModel.updateFriend()
                    showFriendEdit.toggle()
                }
            } label: {
                let icon = NavigationIcon.complete(type: .complete, isEmphasized: !viewModel.nameText.isEmpty)
                
                if let title = icon.title {
                    Text(title)
                        .foregroundStyle(icon.foregroundColor)
                        .padding(.horizontal, DetailFriendUpdate.detailFriendHorizontalPadding)
                        .padding(.vertical, DetailFriendUpdate.detailFriendVerticalPadding)
                        .disabled(!viewModel.nameText.isEmpty)
                }
            }
        }
    }
    
    /// 수정 정보 컨텐츠
    private var friendDetailArea: some View {
        VStack(alignment: .leading, spacing: DetailFriendUpdate.detailFriendSpacing) {
            Text(DetailFriendUpdate.friendDetailDescription)
                .font(.h2)
                .foregroundStyle(.gray80)
            
            textFieldGroup
        }
    }
    
    /// 수정 정보 입력
    private var textFieldGroup: some View {
        VStack(spacing: DetailFriendUpdate.detailFriendTextFieldGroupSpacing, content: {
            makeInfoArea(infoAreaType: .name, text: $viewModel.nameText)
            makeInfoArea(infoAreaType: .birthday, text: $viewModel.birthdayText)
        })
    }
    
    
    /// 중복되는 텍스트 필드 생성
    /// - Parameters:
    ///   - infoAreaType: 텍스트 필드 타입 지정
    ///   - text: 텍스트 필드 값 지정
    /// - Returns: 텍스트 필드 반환
    @ViewBuilder
    private func makeInfoArea(infoAreaType: InfoAreaType, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            
            HStack(content: {
                Text(infoAreaType.title)
                    .foregroundStyle(.gray60)
                
                Spacer()
                
                Text(infoAreaType.guideText(text: text.wrappedValue))
                    .foregroundStyle(.gray40)
                
            })
                .font(.cap2)
            
            
            TextField(infoAreaType.title, text: text, prompt: makePrompt(text: infoAreaType.placeholder))
                .padding(DetailFriendUpdate
                    .detailFriendTextFieldInnerPadding)
                .background {
                    RoundedRectangle(cornerRadius: DetailFriendUpdate.textFieldCornerRadius)
                        .inset(by: 0.5)
                        .fill(Color.background)
                        .stroke(.gray10, style: .init(lineWidth: 1))
                }
                .keyboardType(infoAreaType.keyboardType)
                .onChange(of: viewModel.nameText) { oldValue, newValue in
                
                    if viewModel.nameText.count > 10 {
                        viewModel.nameText = oldValue
                    }
                }
                .onChange(of: viewModel.birthdayText, { oldValue, newValue in
                    viewModel.birthdayText = ConvertDataFormat.shared.formatBirthdayInput(newValue)
                })
                   
        })
    }
    
    @ViewBuilder
    private func makePrompt(text: String) -> Text {
        Text(text)
            .font(.etc)
            .foregroundStyle(Color.gray40)
    }
}

fileprivate enum DetailFriendUpdate {
    // 텍스트
    static let friendDetailDescription: String = "위디 속 친구 정보를 다듬어보세요"
    static let nameText: String = "이름"
    static let birthdayTitleText: String = "생일"
    static let birthdayPlaceHolderText: String = "mm / dd"
    
    // 레이아웃 수치
    static let detailFriendSpacing: CGFloat = 22
    static let detailFriendTopPadding: CGFloat = 16
    static let detailFriendHorizontalPadding: CGFloat = 20
    static let detailFriendVerticalPadding: CGFloat = 20
    
    static let detailFriendAreaSpacing: CGFloat = 40
    static let detailFriendTextFieldGroupSpacing: CGFloat = 20
    
    // TextField 스타일 관련
    static let detailFriendTextFieldInnerPadding: CGFloat = 16
    static let textFieldCornerRadius: CGFloat = 10
}
