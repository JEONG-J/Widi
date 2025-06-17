//
//  HomeDragView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/3/25.
//

import SwiftUI
import UIKit

/// 홈 드래그 뷰
struct HomeDragView: View {
    
    @Bindable var viewModel: HomeViewModel
    @EnvironmentObject var container: DIContainer
    
    // MARK: - Body
    var body: some View {
            VStack(alignment: .center, spacing: 20, content: {
                dragIndicator
                VStack(alignment: .center, spacing: 16, content: {
                    topController
                    
                    scrollOrLoadingView
                })
                Spacer()
            })
            .safeAreaPadding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            .background {
                UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                    .fill(
                        Color.white.opacity(0.55)
                            .shadow(.inner(color: Color.white, radius: 2, x: 2, y: 2))
                    )
                    .background(Material.ultraThin.opacity(0.85), in: UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24))
                    .blurShadow()
                    .ignoresSafeArea()
            }
            .task {
                await viewModel.getMyFriends()
            }
    }
    
    /// 드래그 인디케이터
    private var dragIndicator: some View {
        Capsule()
            .fill(Color.gray30)
            .frame(width: 40, height: 4)
    }
    
    /// 드래그뷰 상단 컨트롤러
    private var topController: some View {
        HStack {
            Text(topTitle)
                .font(.h2)
                .foregroundStyle(Color.gray80)
            
            Spacer()
            
            FriendsAddButton(action: {
                container.navigationRouter.push(to: .addFriendView)
            })
        }
        .padding(.bottom, 20)
    }
    
    /// 하단 친구 리스트 영역
    @ViewBuilder
    private var bottomContents: some View {
        switch viewModel.friendsData {
        case .some(let data) where !data.isEmpty:
            LazyVStack(alignment: .center, spacing: 8) {
                ForEach(data, id: \.id) { friend in
                    FriendsCard(friendsData: friend)
                        .onTapGesture {
                            container.navigationRouter.push(to: .detailFriendView(friendResponse: friend))
                        }
                }
            }
        case .some:
            notContents

        case .none:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var scrollOrLoadingView: some View {
        if viewModel.isLoading {
            progressView
        } else {
            ScrollView(.vertical) {
                bottomContents
            }
            .padding(.bottom, 48)
        }
    }
    
    /// 친구 없을 경우 등장
    @ViewBuilder
    private var notContents: some View {
        Spacer().frame(height: 160)
        
        Text(notContentsText)
            .font(.b1)
            .foregroundStyle(Color.gray50)
            .lineLimit(2)
            .lineSpacing(1.6)
            .multilineTextAlignment(.center)
        
        Spacer()
    }
    
    @ViewBuilder
    private var progressView: some View {
        Spacer()
        
        ProgressView()
            .controlSize(.large)
            .tint(Color.orange30)
        Spacer()
        
            .frame(height: 400)
    }
}

extension HomeDragView {
    private var topTitle: String { "나의 친구들" }
    private var notContentsText: String { "기억하고 싶은 사람이 있나요? \n 친구와의 추억을 위디로 남겨봐요 💌" }
}



#Preview {
    HomeView(container: DIContainer())
        .environmentObject(DIContainer())
}
