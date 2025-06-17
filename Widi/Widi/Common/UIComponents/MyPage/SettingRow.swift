//
//  SettingRow.swift
//  Widi
//
//  Created by jeongminji on 6/2/25.
//

import SwiftUI

/// 마이페이지 설정 리스트 컴포넌트
struct SettingRow: View {
    
    // MARK: - Property
    private let type: SettingRowType
    
    fileprivate enum SettingRowConstants {
        static var leftVerticalPadding: CGFloat = 20
        static var leadingPadding: CGFloat = 4
        static var trailingPadding: CGFloat = 12
        static var stackSpacing: CGFloat = 3
        static var iconFrame: CGFloat = 20
    }
    
    // MARK: - Init
    
    init(type: SettingRowType) {
        self.type = type
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                leftContents
                    .padding(.vertical, SettingRowConstants.leftVerticalPadding)
                
                Spacer()
                
                rightContents
            }
            .padding(.leading, SettingRowConstants.leadingPadding)
            .padding(.trailing, SettingRowConstants.trailingPadding)
        }
        .contentShape(Rectangle())
    }
    
    /// 왼쪽 뷰(타이틀 텍스트, description 텍스트) 생성
    @ViewBuilder
    private var leftContents: some View {
        VStack(alignment: .leading, spacing: SettingRowConstants.stackSpacing) {
            Text(type.title)
                .font(.etc)
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
        case .toggle:
            Image(.chevronForward)
                .resizable()
                .frame(width: SettingRowConstants.iconFrame, height: SettingRowConstants.iconFrame)
            
        case .navigation:
            Image(.chevronForward)
                .resizable()
                .frame(width: SettingRowConstants.iconFrame, height: SettingRowConstants.iconFrame)
            
        case .version(let text):
            Text(text)
                .font(.b1)
                .foregroundStyle(.gray40)
        }
    }
}
