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
    
    @Bindable var viewModel: ContactUsViewModel
    @Binding var isModalPresented: Bool
    
    @FocusState private var isFocusedContactText: Bool
    
    
    // MARK: - Constants
    fileprivate enum ContactUsConstants {
        static let bodyVStackSpacing: CGFloat = 22
        static let sheetTopPadding: CGFloat = 16
        
        static let completedTextHorizonPadding: CGFloat = 20
        static let completedTextVerticalPadding: CGFloat = 10
        
        static let emailTextAreaHeight: CGFloat = 88
        static let emailTextFieldTrailingPadding: CGFloat = 30
        static let emailTextFieldPadding: CGFloat = 16
        static let emailCompleteImageTrailingPadding: CGFloat = 12
        static let emailTextFieldCornerRadius: CGFloat = 10
        
        static let contactTextFieldBottomPadding: CGFloat = 10
        static let warningTextVerticalPadding: CGFloat = 4
        
        static let contactContentsVStackPadding: CGFloat = 14
        static let textInputComponentsStackPadding: CGFloat = 12
        
        static let completeButtonText: String = "완료"
        static let contactDescriptionText: String = "위디에게 궁금한 점이나 전하고 싶은\n이야기를 적어주세요!"
        static let emailPlaceHolderText: String = "이메일"
        static let contactPlaceHolderText: String = "문의 내용을 적어주세요"
        static let warningMessageText: String = "존재하지 않는 이메일입니다"
    }
    
    // MARK: - Init
    init(container: DIContainer, isModalPresented: Binding<Bool>) {
        self.viewModel = .init(container: container)
        self._isModalPresented = isModalPresented
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: ContactUsConstants.bodyVStackSpacing) {
            modalBar
            contactContent
        }
        .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
        .safeAreaPadding(.top, ContactUsConstants.sheetTopPadding)
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
                NavigationIcon.closeX.image
                    .padding(NavigationIcon.closeX.paddingValue)
            }
            
            Spacer()
            
            Button {
                Task {
                    isModalPresented.toggle()
                    await viewModel.complete()
                }
            } label: {
                let icon = NavigationIcon.complete(type: .complete, isEmphasized: viewModel.isAllComplete)
                
                if let title = icon.title {
                    Text(title)
                        .foregroundStyle(icon.foregroundColor)
                        .padding(.horizontal, ContactUsConstants.completedTextHorizonPadding)
                        .padding(.vertical, ContactUsConstants.completedTextVerticalPadding)
                }
            }
            .disabled(!viewModel.isAllComplete)
        }
    }
    
    /// 모달의 컨텐츠 내용 부분 전부
    private var contactContent: some View {
        VStack(alignment: .leading, spacing: ContactUsConstants.contactContentsVStackPadding) {
            Text(ContactUsConstants.contactDescriptionText)
                .font(.h2)
                .foregroundStyle(.gray80)
            
            textInputComponents
        }
    }
    
    /// 모달에서 이메일, 문의내용 입력을 받는 부분
    private var textInputComponents: some View {
        VStack(alignment: .leading, spacing: ContactUsConstants.textInputComponentsStackPadding) {
            emailTextArea
            
            contactTextField
        }
    }
    
    /// 이메일 경고 메시지와 이메일 텍스트 필드 VStack
    @ViewBuilder
    private var emailTextArea: some View {
        
        VStack(alignment: .leading, spacing: .zero) {
            warningMessage
                .animation(.easeInOut, value: viewModel.isEmailComplete)
            
            emailTextField
        }
        .frame(maxHeight: ContactUsConstants.emailTextAreaHeight, alignment: .bottom)
    }
    
    /// 이메일 검증 오류 메시지
    @ViewBuilder
    private var warningMessage: some View {
        if !viewModel.isEmailComplete {
            Text(ContactUsConstants.warningMessageText)
                .padding(.horizontal, ContactUsConstants.emailTextFieldPadding)
                .padding(.vertical, ContactUsConstants.warningTextVerticalPadding)
                .font(.cap2)
                .foregroundStyle(.red30)
        }
    }
    
    /// 이메일 텍스트 필드
    private var emailTextField: some View {
        ZStack {
            TextField("Email", text: $viewModel.emailText, prompt: emailPlaceholder(), )
                .padding(ContactUsConstants.emailTextFieldPadding)
                .padding(.trailing, ContactUsConstants.emailTextFieldTrailingPadding)
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
                .padding(.trailing, ContactUsConstants.emailCompleteImageTrailingPadding)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: ContactUsConstants.emailTextFieldCornerRadius)
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
            .contactTextEditorStyle(text: $viewModel.contactText, placeholder: ContactUsConstants.contactPlaceHolderText)
            .focused($isFocusedContactText)
            .padding(.bottom, ContactUsConstants.contactTextFieldBottomPadding)
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
        Text(ContactUsConstants.emailPlaceHolderText)
            .font(.b1)
            .foregroundStyle(Color.gray40)
    }
}
