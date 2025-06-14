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
    @Binding var isModalPresented: Bool
    
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
        .background(Color.whiteBlack)
    }
    
    /// 모달 맨 위에 들어가는 모달바
    private var modalBar: some View {
        HStack {
            Button {
                isModalPresented.toggle()
            } label: {
                Image(.naviClose)
                    .padding(8)
            }
            
            Spacer()
            
            Button {
                viewModel.complete()
                isModalPresented.toggle()
            } label: {
                let icon = NavigationIcon.complete(type: .complete, isEmphasized: viewModel.isAllComplete)
                
                if let title = icon.title {
                    Text(title)
                        .foregroundStyle(icon.foregroundColor)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
            }
            .disabled(!viewModel.isAllComplete)
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
            emailTextArea
            
            contactTextField
        }
    }
    
    /// 이메일 경고 메시지와 이메일 텍스트 필드 VStack
    @ViewBuilder
    private var emailTextArea: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            warningMessage
                .animation(.easeInOut, value: viewModel.isEmailComplete)
            
            emailTextField
        }
        .frame(maxHeight: 88, alignment: .bottom)
    }
    
    /// 이메일 검증 오류 메시지
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
    
    /// 이메일 텍스트 필드
    private var emailTextField: some View {
        ZStack {
            TextField("Email", text: $viewModel.emailText, prompt: emailPlaceholder(), )
                .padding(.vertical, 16)
                .padding(.horizontal , 16)
                .padding(.trailing, 30)
                .keyboardType(.emailAddress)
                .onChange(of: viewModel.emailText, { oldValue, newValue in
                    guard viewModel.isContactFocusedOnce else { return }
                    
                    viewModel.checkEmailFormat()
                })
            
            if !viewModel.isEmailComplete {
                HStack {
                    Spacer()
                    
                    Image(.error)
                }
                .padding(.trailing, 12)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .fill(Color.background)
                .stroke(returnCompleted().0, style: .init(lineWidth: returnCompleted().1))
        }
    }
    
    /// 이메일 작성 오류시 텍스트 필드 보더 변환
    /// - Returns: 텍스트 필드 보더 색, 두께
    private func returnCompleted() -> (Color, CGFloat) {
        if viewModel.isEmailComplete {
            return (Color.gray10, 1)
        } else {
            return (Color.red30, 2)
        }
    }
    
    /// 문의 내용 텍스트 필드
    private var contactTextField: some View {
        TextEditor(text: $viewModel.contactText)
            .contactTextEditorStyle(text: $viewModel.contactText, placeholder: contactPlaceHolderText)
            .focused($isFocusedContactText)
            .padding(.bottom, 10)
            .onChange(of: isFocusedContactText) { oldValue, newValue in
                /* 문의 내용 한 번 이상 왔는가?,  문의 내용 작성 전, 이메일 입력 하자마자 오류 검증 하는 것을 막기 위함 */
                if viewModel.isContactFocusedOnce == false {
                    viewModel.isContactFocusedOnce = true
                }
                
                /* 이메일 안 적고 넘어왔을 때 */
                if newValue {
                    viewModel.checkEmailFormat()
                }
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
    private var warningMessageText: String { "존재하지 않는 이메일입니다" }
}

#Preview {
    ContactUsView(isModalPresented: .constant(true))
}
