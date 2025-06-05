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
            topContents
            
            Spacer()
            
            buttonContetns
            
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.top, 24)
        .safeAreaPadding(.bottom, 51)
        .background(Color.background)
        .sheet(isPresented: $myPageViewModel.isModalPresented) {
            ContactUsView()
                .presentationCornerRadius(24)
        }
    }
    
    // MARK: - Top
    
    /// 상단 + 중앙 컨텐츠
    private var topContents: some View {
        VStack(spacing: 46) {
            topName
            middleContents
        }
        .padding(.top, 24)
    }
    
    
    /// 유저 이름 뷰
    private var topName: some View {
        Text("zani0430")
            .font(.h1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 4)
    }
    
    // MARK: - Middle
    
    /// 중앙 컨텐츠 리스트 버트
    private var middleContents: some View {
        
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
    }
    
    // MARK: - Bottom
    
    private var buttonContetns: some View {
        VStack(spacing: 29) {
            logOutButton
            
            deleteAccountButton
        }
        .frame(height: 93)
        .safeAreaPadding(.horizontal, 97)
    }
    
    /// 로그아웃 버튼
    private var logOutButton: some View {
        Button {
            myPageViewModel.logOutAction()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray70)
                    .frame(maxWidth: .infinity, minHeight: 44)
                
                Text(logoutText)
                    .font(.btn)
                    .foregroundStyle(.white)
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
