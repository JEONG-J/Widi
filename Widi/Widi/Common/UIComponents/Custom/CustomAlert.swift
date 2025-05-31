//
//  CustomAlert.swift
//  Widi
//
//  Created by Apple Coding machine on 5/31/25.
//

import SwiftUI

struct CustomAlert: View {
    
    // MARK: - Property
    
    var onCancel: () -> Void
    var onDelete: () -> Void
    
    // MARK: - Init
    
    /// 취소 또는 삭제 초기화
    /// - Parameters:
    ///   - onCancel: 취소 액션
    ///   - onDelete: 삭제 액션
    init(onCancel: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.onCancel = onCancel
        self.onDelete = onDelete
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            topContents
            
            bottomButton
        }
        .frame(width: 272)
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 16)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color(red: 0.17, green: 0.17, blue: 0.18).opacity(0.06), radius: 10, x: 0, y: 8)
                .blur(radius: 15)
        }
    }
    
    /// Alert 상단 텍스트
    private var topContents: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            ForEach(AlertTopText.allCases, id: \.self) { btn in
                Text(btn.text)
                    .font(btn.font)
                    .foregroundStyle(btn.color)
            }
        })
    }
    
    /// Alert 하단 버튼 그룹
    private var bottomButton: some View {
        HStack(spacing: 8) {
            ForEach(AlertButton.allCases, id: \.self) { btn in
                Button(action: {
                    action(for: btn)()
                }, label: {
                    Text(btn.text)
                        .foregroundStyle(btn.color)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                })
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .font(.btn)
    }
    
    /// 버튼 액션 분리
    /// - Parameter button: 버튼 타입
    /// - Returns: 버튼에 맞도록 액션 연결
    private func action(for button: AlertButton) -> () -> Void {
        switch button {
        case .cancelText:
            return onCancel
        case .deleteText:
            return onDelete
        }
    }
}

#Preview {
    CustomAlert(onCancel: {
        print("hello")
    }, onDelete: {
        print("hello")
    })
}
