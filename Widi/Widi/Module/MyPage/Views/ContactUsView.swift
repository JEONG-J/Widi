//
//  ContactUsView.swift
//  Widi
//
//  Created by 김성현 on 2025-06-03.
//

import SwiftUI

/// 문의하기 뷰
struct ContactUsView: View {
    
    // MARK: - Property
    
    @Bindable var viewModel: ContactUsViewModel = .init()
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocusedContactText: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            modalBar
            contactContent
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.top, 16)
        .task {
            UIApplication.shared.hideKeyboard()
        }
    }
    
    /// 모달 맨 위에 들어가는 모달바
    private var modalBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(.naviClose)
                    .padding(8)
            }
            
            Spacer()
            
            Button {
                viewModel.complete(eamilText: viewModel.emailText, contactText: viewModel.contactText)
            } label: {
                Text(NavigationIcon.complete(type: .complete, isEmphasized: false).title ?? "")
                    .font(.h4)
//                    .foregroundStyle(completeButtonColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
        }
    }
    
    /// 모달의 컨텐츠 내용 부분 전부
    private var contactContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(contactDescriptionText)
                .font(.h2)
                .foregroundStyle(.gray80)
            
            textInputComponents
        }
    }
    
    /// 모달에서 이메일, 문의내용 입력을 받는 부분
    private var textInputComponents: some View {
        VStack(alignment: .leading, spacing: 12) {
            emailTextField
            
            contactTextField
        }
    }
    
    @ViewBuilder
    private var emailTextField: some View {
        
        VStack(alignment: .leading) {
            warningMessage
                .animation(.easeInOut, value: viewModel.isEmailComplete)
            
            TextField("Email", text: $viewModel.emailText, prompt: emailPlaceholder())
                .padding(.vertical, 12)
                .padding(.horizontal , 16)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .fill(Color.background)
                        .stroke(Color.gray10, style: .init(lineWidth: 1))
                }
                .onSubmit {
                    viewModel.checkEmailFormat()
                }
        }
        .frame(maxHeight: 88, alignment: .bottom)
    }
    
    private var contactTextField: some View {
        TextEditor(text: $viewModel.contactText)
            .contactTextEditorStyle(text: $viewModel.contactText, placeholder: contactPlaceHolderText)
            .focused($isFocusedContactText)
            .padding(.bottom, 10)
            .onChange(of: isFocusedContactText) { oldValue, newValue in
                if newValue {
                    viewModel.checkEmailFormat()
                }
            }
    }
    
    @ViewBuilder
    private var warningMessage: some View {
        if !viewModel.isEmailComplete {
            Text(warningMessageText)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .font(.cap2)
                .foregroundStyle(.red30)
        }
    }
    
    /// 이메일 placeholder Text 생성 함수 (focus 되었을 때 placeholder가 안보이게 커스텀)
    /// - Returns: 이메일 placeholder
    private func emailPlaceholder() -> Text {
        Text(emailPlaceHolderText)
            .font(.b1)
            .foregroundStyle(Color.gray40)
    }
    
}

extension ContactUsView {
    private var completeButtonText: String { "완료" }
    private var contactDescriptionText: String { "위디에게 궁금한 점이나 전하고 싶은\n이야기를 적어주세요!" }
    private var emailPlaceHolderText: String { "이메일" }
    private var contactPlaceHolderText: String { "문의 내용을 적어주세요" }
    private var warningMessageText: String { "존재하지 않는 이메일입니다." }
}

#Preview {
    ContactUsView()
}
