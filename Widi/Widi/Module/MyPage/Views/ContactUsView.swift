//
//  ContactUsView.swift
//  Widi
//
//  Created by 김성현 on 2025-06-03.
//

import SwiftUI

struct ContactUsView: View {
    
    @State var emailText: String = ""
    @State var contactText: String = ""
    
    func complete() {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            modalBar
            contactContent
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.top, 16)
    }
    
    private var modalBar: some View {
        HStack {
            Image(.naviClose)
                .padding(8)
            
            Spacer()
            
            Button {
                complete()
            } label: {
                Text(completeButtonText)
                    .font(.h4)
                    .foregroundStyle(.gray40)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
        }
    }
    
    private var contactContent: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text(contactDescriptionText)
                .font(.h2)
                .foregroundStyle(.gray80)
            
            textInputComponents
        }
    }
    
    private var textInputComponents: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Email", text: $emailText, prompt: placeholder())
                .padding(.vertical, 12)
                .padding(.horizontal , 16)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .fill(Color.background)
                        .stroke(Color.gray10, style: .init(lineWidth: 1))
                }
            
            TextEditor(text: $contactText)
                .contactTextEditorStyle(text: $contactText, placeholder: contactPlaceHolderText)
                .padding(.bottom, 10)
        }
    }
    
    private func placeholder() -> Text {
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
}

#Preview {
    ContactUsView()
}
