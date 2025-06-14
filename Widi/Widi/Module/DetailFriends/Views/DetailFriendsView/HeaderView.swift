//
//  HeaderView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/14/25.
//

import SwiftUI

/// 스크롤 시 사라지는 뷰, 친구 정보 뷰
struct HeaderView: View {
    
    // MARK: - Property
    let friendResponse: FriendResponse
    let headerHeight: CGFloat
    
    // MARK: - init
    /// 친구 정보 init
    /// - Parameters:
    ///   - friendData: 친구
    ///   - headerHeight: 헤더 높이 지정
    init(friendResponse: FriendResponse, headerHeight: CGFloat) {
        self.friendResponse = friendResponse
        self.headerHeight = headerHeight
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = max(0, size.height + minY)
            let threshhold = -(getScreenSize().height * 0.05)
            
            VStack(alignment: .leading, spacing: 32) {
                topProfileInfo
                friendsDetailInfo(minY, threshhold)
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
            .frame(width: size.width, height: height)
            .offset(y: -minY)
        }
        .frame(height: headerHeight)
    }
    
    // MARK: - FriendsInfo
    
    /// 친구 이름 및 프로필 사진
    private var topProfileInfo: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(friendResponse.name)
                .font(.h1)
                .foregroundStyle(.gray80)
            
            CustomProfileImage(
                imageURLString: friendResponse.experienceDTO.characterInfo.imageURL,
                size: 40
            )
        }
    }
    
    /// 친구 상세 정보
    @ViewBuilder
    private func friendsDetailInfo(_ minY: CGFloat, _ threshhold: CGFloat) -> some View {
        FriendInfoView(friendInfoData: friendResponse)
            .frame(maxWidth: .infinity)
            .frame(height: 101)
            .opacity(threshhold > minY ? 0 : 1)
            .animation(.easeInOut(duration: 0.3), value: threshhold > minY)
    }
}
