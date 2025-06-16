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
    
    @Bindable var viewModel: MyPageViewModel
    @EnvironmentObject var contaier: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    // MARK: - Init
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.viewModel = .init(container: container, appFlowViewModel: appFlowViewModel)
    }
    
    fileprivate enum MyPageConstants {
        static let logoutText: String = "로그아웃"
        static let deleteAccountText: String = "탈퇴하기"
        static let settingRowNavigationDescription: String = "모든 알림 전송이 일시 중단돼요"
        
        static let viewTopPadding: CGFloat = 24
        static let sheetCornerRadius: CGFloat = 24
        static let topContentsSpacing: CGFloat = 46
        static let nameLeadingPadding: CGFloat = 4
        
        static let bottomContentsHeight: CGFloat = 24
        static let bottomContentSpacing: CGFloat = 29
        static let bottomContentsHorizonPadding: CGFloat = 110
        static let buttonCornerRadius: CGFloat = 8
        static let buttonHeight: CGFloat = 44
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            if viewModel.isLoading {
                progressView
            } else {
                topContents
                
                Spacer()
                
                buttonContents
            }
        }
        .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
        .safeAreaPadding(.top, MyPageConstants.viewTopPadding)
        .safeAreaPadding(.bottom, UIConstants.defaultBottomPadding)
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading, content: {
                CustomNavigationIcon(navigationIcon: .backArrow, action: {
                    contaier.navigationRouter.pop()
                })
            })
        })
        .sheet(isPresented: $viewModel.isModalPresented) {
            ContactUsView(container: contaier, isModalPresented: $viewModel.isModalPresented)
                .presentationCornerRadius(MyPageConstants.sheetCornerRadius)
        }
        .alertModifier(show: viewModel.isShowLogoutAlert, content: {
            CustomAlert(
                alertButtonType: .logoutUser,
                onCancel: {
                    viewModel.isShowLogoutAlert.toggle()
                },
                onRight: {
                    Task {
                        await viewModel.logOutAction()
                    }
                })
        })
        .alertModifier(show: viewModel.isShowDrawAlert, content: {
            CustomAlert(alertButtonType: .withdrawUser,
                        onCancel: {
                viewModel.isShowDrawAlert.toggle()
            },
                        onRight: {
                Task {
                    await viewModel.deleteAccountAction()
                    self.viewModel.isShowDrawAlert.toggle()
                }
            })
        })
        .task {
            await viewModel.getMyInfo()
        }
    }
    
    // MARK: - Top
    
    /// 상단 + 중앙 컨텐츠
    private var topContents: some View {
        VStack(spacing: MyPageConstants.topContentsSpacing) {
            topName
            middleContents
        }
    }
    
    
    /// 유저 이름 뷰
    private var topName: some View {
        Text(viewModel.userInfo?.name ?? "유저 이름 정보 없음")
            .font(.h1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, MyPageConstants.nameLeadingPadding)
    }
    
    // MARK: - Middle
    
    /// 중앙 컨텐츠 리스트 버트
    private var middleContents: some View {
        let toggleBinding = Binding(
            get: {
                viewModel.userInfo?.toogle ?? true
            },
            set: { newValue in
                viewModel.userInfo?.toogle = newValue
                Task {
                    await viewModel.toggleOnOff()
                }
            })
        
        let settings: [SettingRowType] = [
                .toggle(
                    isOn: toggleBinding,
                    description: MyPageConstants.settingRowNavigationDescription
                ),
                .navigation,
                .version(text: viewModel.appVersion ?? "")
            ]
        
        return VStack(spacing: .zero) {
            
            Divider()
            
            ForEach(Array(settings.enumerated()), id: \.offset) { index, rowType in
                switch rowType {
                case .navigation:
                    SettingRow(type: rowType)
                        .onTapGesture {
                            viewModel.isModalPresented = true
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
    
    private var buttonContents: some View {
        VStack(spacing: MyPageConstants.bottomContentSpacing) {
            logOutButton
            
            deleteAccountButton
        }
        .safeAreaPadding(.horizontal, MyPageConstants.bottomContentsHorizonPadding)
        .frame(height: MyPageConstants.bottomContentsHeight)
    }
    
    /// 로그아웃 버튼
    private var logOutButton: some View {
        Button {
            withAnimation(.easeInOut) {
                viewModel.isShowLogoutAlert.toggle()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: MyPageConstants.buttonCornerRadius)
                    .fill(Color.gray70)
                    .frame(maxWidth: .infinity, minHeight: MyPageConstants.buttonHeight)
                
                Text(MyPageConstants.logoutText)
                    .font(.btn)
                    .foregroundStyle(.white)
            }
        }
    }
    
    /// 탈퇴하기 버튼
    private var deleteAccountButton: some View {
        Button {
            withAnimation(.easeInOut) {
                viewModel.isShowDrawAlert.toggle()
            }
        } label: {
            Text(MyPageConstants.deleteAccountText)
                .font(.cap2)
                .foregroundStyle(.black)
                .underline(true, pattern: .solid)
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        Spacer()
        
        ProgressView()
            .tint(Color.orange30)
        
        Spacer()
    }
}

#Preview {
    MyPageView(container: DIContainer(), appFlowViewModel: AppFlowViewModel())
        .environmentObject(DIContainer())
        .environmentObject(AppFlowViewModel())
}
