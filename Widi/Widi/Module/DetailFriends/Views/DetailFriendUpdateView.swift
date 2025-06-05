//
//  DetailFriendUpdatedView.swift
//  Widi
//
//  Created by Miru on 2025/6/5.
//

import SwiftUI

struct DetailFriendUpdateView: View {

    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: DetailFriendUpdateViewModel = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            modalBar
            
            friendDetailArea
            
            Spacer()
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.top, 16)
        .task {
            UIApplication.shared.hideKeyboard()
        }
        .background(Color.whiteBlack)
    }
    
    /// 모달 맨 위에 들어가는 모달바
    private var modalBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                NavigationIcon.closeX.image
                    .padding(8)
            }
            
            Spacer()
            
            Button {
                viewModel.complete()
            } label: {
                let icon = NavigationIcon.complete(type: .complete, isEmphasized: !viewModel.nameText.isEmpty)
                
                if let title = icon.title {
                    Text(title)
                        .foregroundStyle(icon.foregroundColor)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .disabled(!viewModel.nameText.isEmpty)
                }
            }
        }
    }
    
    private var friendDetailArea: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text(friendDetailDescription)
                .font(.h2)
                .foregroundStyle(.gray80)
            
            textFieldGroup
            }
        }
    
    private var textFieldGroup: some View {
        VStack(spacing: 20, content: {
            
            makeInfoArea(infoAreaType: .name, text: $viewModel.nameText)
            makeInfoArea(infoAreaType: .birthday, text: $viewModel.birthdayText)
        })
    }
    
    
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
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 10)
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

extension DetailFriendUpdateView {
    private var friendDetailDescription: String { "위디 속 친구 정보를 다듬어보세요" }
    private var nameTitleText: String { "이름" }
    private var namePlaceHolderText: String { "이름" }
    private var birthdayTitleText: String { "생일" }
    private var birthdayPlaceHolderText: String { "mm / dd" }
}

#Preview {
    DetailFriendUpdateView()
}

enum InfoAreaType {
    case birthday
    case name
    
    var title: String {
        switch self {
        case .birthday:
            return "생일"
        case .name:
            return "이름"
        }
    }
    
    var placeholder: String {
        switch self {
        case .birthday:
            "mm / dd"
        case .name:
            "이름"
        }
    }
    
    func guideText(text: String) -> String {
        switch self {
        case .birthday:
            return ""
        case .name:
            return "\(text.count) / 10"
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .birthday:
            return .numberPad
        case .name:
            return .default
        }
    }
}
