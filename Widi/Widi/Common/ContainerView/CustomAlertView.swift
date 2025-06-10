//
//  CustomAlertView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/9/25.
//

import SwiftUI

struct CustomAlertView<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            Color.dimmed
                .ignoresSafeArea(.all)
            
            content()
                .padding(.leading, 40)
                .padding(.trailing, 41)
        }
    }
}

#Preview {
    CustomAlertView(content: {
        CustomAlert(alertButtonType: .diaryDelete, onCancel: {
            print("hello")
        }, onRight: {
            print("hello")
        })
    })
}
