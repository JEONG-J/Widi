//
//  MyPageView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import SwiftUI

/// 마이페이지 뷰
struct MyPageView: View {
    
    // MARK: - Property
    
    @State var myPageViewModel: MyPageViewModel = .init()
    
    // MARK: - Body
    var body: some View {
        VStack {
            VStack(spacing:46) {
                topName
                settingRow
            }
            .padding(.top, 24)
            Spacer()
            logOutButton
                .padding(.bottom, 29)
            deleteAccountButton
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.top, 24)
        .safeAreaPadding(.bottom, 51)
    }
    
    /// 유저 이름 뷰
    private var topName: some View {
        Text("zani0430")
            .font(.h1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 4)
    }
    
    /// 로그아웃 버튼
    // TODO: - 지나의 도움 필요! 사이즈 너무 작음
    private var logOutButton: some View {
        Button {
            myPageViewModel.logOutAction()
        } label: {
            Text(logoutText)
                .font(.cap1)
                .foregroundStyle(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 60)
                .background {
                    RoundedRectangle(cornerRadius:8)
                        .fill(Color.gray70)
                }
        }
    }
    
    /// 탈퇴하기 버튼
    private var deleteAccountButton: some View {
        Button {
            myPageViewModel.deleteAccountAction()
        } label: {
            Text(deleteAccountText)
                .font(.cap2)
                .foregroundStyle(.black)
                .underline(true, pattern: .solid)
        }
    }
    
    /// 설정 리스트
    private var settingRow: some View {
        
        let settings: [SettingRowType] = [
            .toggle(
                isOn: $myPageViewModel.toggleOption,
                description: settingRowNavigationDescription,
                onToggleChanged: myPageViewModel.toggleOnOff
            ),
            .navigation,
            .version(text: myPageViewModel.appVersion!)
        ]
        
        return VStack(spacing: 0) {
            
            Divider()
            
            ForEach(Array(settings.enumerated()), id: \.offset) { index, rowType in
                switch rowType {
                case .navigation:
                    SettingRow(type: rowType)
                        .onTapGesture {
                            myPageViewModel.isModalPresented = true
                        }
                default:
                    SettingRow(type: rowType)
                }
                
                Divider()
                    .foregroundStyle(.gray20)
            }
        }
        .sheet(isPresented: $myPageViewModel.isModalPresented) {
            ContactUsView()
        }
    }
}

extension MyPageView {
    private var logoutText: String { "로그아웃" }
    private var deleteAccountText: String { "탈퇴하기" }
    private var settingRowNavigationDescription: String { "모든 알림 전송이 일시 중단돼요" }
}

struct Mypage_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 16 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyPageView()
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }
    }

}
