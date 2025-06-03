//
//  CustomTextEditor.swift
//  Widi
//
//  Created by Apple Coding machine on 6/3/25.
//

import SwiftUI

struct CustomTextEditor: ViewModifier {
    
    // MARK: - Property
    @FocusState private var isFocused: Bool
    @Binding var text: String
    let placeholder: String
    let background: Color
    let padding: CGFloat = 16
    
    init(
        text: Binding<String>,
        placeholder: String,
        background: Color = Color.background
    ) {
        self._text = text
        self.placeholder = placeholder
        self.background = background
    }
    
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .padding(padding)
            .background(alignment: .topLeading, content: {
                if text.isEmpty && !isFocused {
                    Text(placeholder)
                        .padding(padding)
                        .font(.b1)
                        .foregroundStyle(Color.gray40)
                }
            })
            .textInputAutocapitalization(.none)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .fill(background)
                    .stroke(Color.gray10, style: .init(lineWidth: 1))
            }
            .font(.b1)
            .foregroundStyle(Color.gray80)
            .scrollIndicators(.visible)
            .scrollContentBackground(.hidden)
    }
}

extension TextEditor {
    func contactTextEditorStyle(text: Binding<String>, placeholder: String) -> some View {
        self.modifier(CustomTextEditor(text: text, placeholder: placeholder))
    }
}
