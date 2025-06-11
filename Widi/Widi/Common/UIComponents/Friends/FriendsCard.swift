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

#Preview {
    FriendsCard(friendsData: .init(documentId: "0", friendId: "0", name: "지나", experienceDTO: .init(experiencePoint: 0, characterInfo: .init(imageURL: "https://i.namu.wiki/i/e0lH4DdMFmKDm2Pf6nZtxpXjrUAn6hJSv_ecLV9l3BCof60YlFP-AU2EanXKubX1mttxSeAG5DyxD0QW-qbZ-qxVGPPdqHsPSSx1fdTRkv-jFuQC5CdWCUBsWHblz-zzIrqYrgFhoYO4Hr1B-RymVQ.webp", x: 9, y: 9))))
}
