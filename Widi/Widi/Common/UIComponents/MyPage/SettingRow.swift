//
//  SettingRow.swift
//  Widi
//
//  Created by jeongminji on 6/2/25.
//

import SwiftUI

struct SettingRow: View {
    
    // MARK: - Property
    
    private let type: SettingRowType
    
    // MARK: - Init
    
    /// SettingRow
    /// - Parameters:
    ///   - type: toggle, navigation, version 중 택 1
    init(type: SettingRowType) {
        self.type = type
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                leftContents
                    .padding(.vertical, 20)
                
                Spacer()
                
                rightContents
            }
            .padding(.leading, 4)
            .padding(.trailing, 12)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray20)
        }
        .contentShape(Rectangle())
    }
    
    /// 왼쪽 뷰(타이틀 텍스트, description 텍스트) 생성
    @ViewBuilder
    private var leftContents: some View {
        VStack(alignment: .leading, spacing: 3) {
            // TODO: - pretendard-medium, size: 18로 디자인 시스템에 없는 폰트 -> 확인 필요
            Text(type.title)
                .font(.h4)
                .foregroundStyle(.gray80)
            
            if let description = type.description {
                Text(description)
                    .font(.cap2)
                    .foregroundStyle(.gray50)
            }
        }
    }
    
    /// 오른쪽 뷰(토글, 화살표, 버전 정보 텍스트) 생성
    @ViewBuilder
    private var rightContents: some View {
        switch type {
        case .toggle(let isOn, _):
            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(
                    SwitchToggleStyle(tint: Color.orange30)
                )
        case .navigation:
            Image(.chevronForward)
                .resizable()
                .frame(width: 20, height: 20)
        case .version(let text):
            Text(text)
                .font(.b1)
                .foregroundStyle(.gray40)
        }
    }
}

#Preview {
    @Previewable @State var isPushEnabled = true
    @Previewable @State var isModalPresented = false
    
    VStack(spacing: 0) {
        SettingRow(
            type: .toggle(
                isOn: $isPushEnabled,
                description: "모든 알림 전송이 일시 중단돼요"
            )
        )
        
        SettingRow(type: .navigation)
            .onTapGesture {
                isModalPresented = true
            }
        
        SettingRow(type: .version(text: "25.4.2"))
    }
    .padding(.horizontal, 16)
    .sheet(isPresented: $isModalPresented) {
        Text("문의하기 모달 열림!")
            .font(.largeTitle)
            .padding()
    }
}
