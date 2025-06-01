//
//  CustomNavigationComponent.swift
//  Widi
//
//  Created by 김성현 on 2025-05-30.
//

import SwiftUI

/// 커스텀 네비게이션 바  컴포넌트
struct CustomNavigationBar: View {
    
    /// 앞에 위치한 버튼을 선택할 수 있는 enum
    enum LeadingType {
        case arrowLeft(arrowLeft: () -> Void)
        case close(close: () -> Void)
    }
    
    /// 뒤에 위치한 버튼을 선택할 수 있는 enum
    /// 각각의 버튼에 해당하는 함수를 바로 받을 수 있게 해두었다.
    enum TrailingType {
        case editDelete(edit: () -> Void, delete: () -> Void)
        case close(close: () -> Void)
        case grayComplete(complete: () -> Void)
        case redComplete(complete: () -> Void)
        case none
    }
    
    /// 앞에 위치한 버튼을 선택받는다.
    private let leadingType: LeadingType
    /// 뒤에 위치한 버튼을 선택받는다.
    private let trailingType: TrailingType
    /// 네비게이션 title이 필요한 경우 받는다.
    private let title: String?
    
    init(leadingType: LeadingType,
         trailingType: TrailingType,
         title: String? = nil) {
        self.leadingType = leadingType
        self.trailingType = trailingType
        self.title = title
    }
    
    var body: some View {
        ZStack {
            titleView
            HStack {
                leadingButton
                Spacer()
                trailingButton
            }
        }
    }
    
    /// 네비게이션 title을 파라미터로 받으면 띄워주는 View
    @ViewBuilder
    private var titleView: some View {
        if let title = title {
            Text(title)
                .font(.h4)
        } else {
            EmptyView()
        }
    }
    
    /// 앞에 위치한 버튼 View
    @ViewBuilder
    private var leadingButton: some View {
        switch leadingType {
        case .arrowLeft(let arrowLeft):
            IconCircleButton(imageName: "arrow-left", action: arrowLeft)
        case .close(let close):
            IconCircleButton(imageName: "close", action: close)
        }
    }
    
    /// 뒤에 위치한 버튼 View
    @ViewBuilder
    private var trailingButton: some View {
        switch trailingType {
        case .editDelete(let edit, let delete):
            HStack (alignment: .center, spacing:12) {
                IconCircleButton(imageName: "edit", action: edit)
                IconCircleButton(imageName: "delete", action: delete)
            }
        case .close(let close):
            IconCircleButton(imageName: "close", action: close)
        case .grayComplete(let complete):
            CompleteButton(colorName: .gray40, action: complete)
        case .redComplete(let complete):
            CompleteButton(colorName: .oragne30, action: complete)
        case .none:
            EmptyView()
        }
    }
    
    /// 원 안에 아이콘이 들어가는 컴포넌트
    private struct IconCircleButton: View {
        let imageName: String
        let action: () -> Void
        
        init(imageName: String,
             action: @escaping () -> Void) {
            self.imageName = imageName
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .frame(width:40, height:40)
                        .foregroundStyle(.white)
                        .shadow(color: Color(red: 0.93, green: 0.25, blue: 0.09).opacity(0.03), radius: 4, x: 0, y: 8)
                        .shadow(color: Color(red: 0.55, green: 0.13, blue: 0.05).opacity(0.03), radius: 2, x: 1, y: 3)
                        .shadow(color: Color(red: 0.67, green: 0.54, blue: 0.5).opacity(0.03), radius: 3, x: 0, y: 2)
                    Image(imageName)
                }
            }
        }
    }
    
    /// 네모 안에 "완료" 글자가 들어가는 컴포넌트
    private struct CompleteButton: View {
        let colorName: Color
        let action: () -> Void
        
        init(colorName: Color,
             action: @escaping () -> Void)
        {
            self.colorName = colorName
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    Rectangle()
                        .frame(width: 88, height: 40)
                        .foregroundStyle(.white)
                        .cornerRadius(20)
                        .shadow(color: Color(red: 0.93, green: 0.25, blue: 0.09).opacity(0.03), radius: 4, x: 0, y: 8)
                        .shadow(color: Color(red: 0.55, green: 0.13, blue: 0.05).opacity(0.03), radius: 2, x: 1, y: 3)
                        .shadow(color: Color(red: 0.95, green: 0.37, blue: 0.23).opacity(0.03), radius: 3, x: 0, y: 2)
                    Text("완료")
                        .font(.h4)
                        .foregroundStyle(colorName)
                }
            }
        }
    }
}


#Preview {
    ZStack {
        CustomNavigationBar(
            leadingType: .close(close: {}),
            trailingType: .editDelete(edit: {}, delete: {})
        )
    }
}
