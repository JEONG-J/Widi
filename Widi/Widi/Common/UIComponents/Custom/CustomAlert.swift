//
//  CustomAlert.swift
//  Widi
//
//  Created by Apple Coding machine on 5/31/25.
//

import SwiftUI

/// 커스텀 Alert 컴포넌트
struct CustomAlert: View {
    
    // MARK: - Property
    
    var alertButtonType: AlertButtonType
    var onCancel: () -> Void
    var onRight: () -> Void
    
    // MARK: - Init
    
    /// 취소 또는 삭제 초기화
    /// - Parameters:
    ///   - alertButtonType: Alert 타입 지정
    ///   - onCancel: 취소 액션
    ///   - onRight: 오른쪽 버튼 액션
    init(
        alertButtonType: AlertButtonType,
        onCancel: @escaping () -> Void,
        onRight: @escaping () -> Void
    ) {
        self.alertButtonType = alertButtonType
        self.onCancel = onCancel
        self.onRight = onRight
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            topContents
            
            bottomButton
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 16)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.whiteBlack)
                .shadow(color: Color(red: 0.17, green: 0.17, blue: 0.18).opacity(0.06), radius: 10, x: 0, y: 8)
        }
    }
    
    /// Alert 상단 텍스트
    private var topContents: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text(alertButtonType.title)
                .foregroundStyle(Color.gray80)
                .font(.h3)
            
            Text(alertButtonType.subtitle)
                .foregroundStyle(Color.gray50)
                .font(.b2)
                .lineSpacing(2.0)
        })
    }
    
    /// Alert 하단 버튼 그룹
    private var bottomButton: some View {
        HStack(spacing: 8) {
            
            Spacer()
            
            ForEach(alertButtonType.buttons, id: \.self) { btn in
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
        .frame(alignment: .trailing)
        .font(.btn)
    }
    
    /// 버튼 액션 분리
    /// - Parameter button: 버튼 타입
    /// - Returns: 버튼에 맞도록 액션 연결
    private func action(for button: AlertButton) -> () -> Void {
        switch button {
        case .continuation, .returnTo:
            return onCancel
        default:
            return onRight
        }
    }
}
