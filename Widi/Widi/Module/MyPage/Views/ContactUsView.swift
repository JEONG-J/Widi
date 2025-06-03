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
    
    func complete() {
        
    }
    
    var body: some View {
        VStack(spacing: 22) {
            modalBar
            contactContent
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.top, 16)
        Spacer()
    }
    
    private var modalBar: some View {
        HStack {
            Image(.naviClose)
            Spacer()
            Button {
                complete()
            } label: {
                Text(completeButtonText)
                    .font(.h4)
                    .foregroundStyle(.gray40)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 9)
            }
        }
    }
    
    private var contactContent: some View {
        VStack(spacing: 40) {
            Text(contactDescriptionText)
                .font(.h2)
                .foregroundStyle(.gray80)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 12) {
                TextField(emailPlaceHolderText, text: $emailText)
                    .background(.background)
                TextField(contactPlaceHolderText, text: $contactText)
            }
        }
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
