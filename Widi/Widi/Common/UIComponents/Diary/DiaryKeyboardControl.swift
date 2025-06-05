//
//  DiaryKeyboardControl.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import SwiftUI

struct DiaryKeyboardControl: View {
    
    @Binding var isShowCalendar: Bool
    @Binding var isShowImagePicker: Bool
    
    var body: some View {
        HStack(spacing: 8, content: {
            makeButton(image: Image(.calendar), action: {
                isShowCalendar.toggle()
            })
            
            makeButton(image: Image(.album), action: {
                isShowImagePicker.toggle()
            })
            
            Spacer()
        })
        .frame(height: 48)
        .background(Color.bottomControl)
    }
    
    @ViewBuilder
    private func makeButton(image: Image, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            image
                .renderingMode(.template)
                .foregroundStyle(Color.gray60)
                .fixedSize()
                .padding(8)
        })
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DiaryKeyboardControl(isShowCalendar: .constant(false), isShowImagePicker: .constant(false))
}
