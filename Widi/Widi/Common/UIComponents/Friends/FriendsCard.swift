//
//  FriendsCard.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI
import Kingfisher

/// 친구 이름과 프로필 카드 컴포넌트
struct FriendsCard: View {
    
    // MARK: - Property
    let friendsData: FriendResponse
    
    // MARK: - Init
    
    init(friendsData: FriendResponse) {
        self.friendsData = friendsData
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 12, content: {
            CustomProfileImage(imageURLString: friendsData.experienceDTO.characterInfo.imageURL)
            
            Text(friendsData.name)
                .font(.h3)
                .foregroundStyle(Color.gray80)
                .frame(maxWidth: .infinity, alignment: .leading)
        })
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.whiteBlack)
                .frame(maxWidth: .infinity, minHeight: 68)
                .shadow1()
        }
    }
}
