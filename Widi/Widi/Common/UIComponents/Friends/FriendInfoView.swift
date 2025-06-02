//
//  FriendInfoView.swift
//  Widi
//
//  Created by jeongminji on 6/2/25.
//

import SwiftUI

struct FriendInfoView: View {
    
    // MARK: - Property

    private let infoItems: [FriendInfoItem]

    // MARK: - Init
    
    /// FriendInfoView
    /// - Parameter friendInfoData: 친구 정보 조회 데이터
    init(friendInfoData: FriendResponse) {
        self.infoItems = FriendInfoItem.makeItems(from: friendInfoData)
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(infoItems.indices, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text(infoItems[index].title)
                        .font(.b2)
                        .foregroundStyle(.gray50)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    contentView(for: infoItems[index])
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 24)
            }
        }
        .padding(.vertical, 13)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.whiteBlack.opacity(0.3))
        )
        .glass()
    }
    
    /// FriendInfoItem 타입에 따라 그려주는 ViewBuilder
    @ViewBuilder
    private func contentView(for item: FriendInfoItem) -> some View {
        if let valueText = item.valueText {
            Text(valueText)
                .font(.h2)
                .foregroundStyle(.gray80)
        } else if let progress = item.hatchProgressValue {
            HatchProgressDotsView(progress: progress)
        }
    }
}

fileprivate struct HatchProgressDotsView: View {
    private var progress: Int
    private let total: Int
    
    init(progress: Int, total: Int? = 4) {
        self.progress = progress
        self.total = total ?? 4
    }
    
    var body: some View {
        Group {
            if progress < total {
                HStack(spacing: 8) {
                    ForEach(0..<total, id: \.self) { index in
                        Circle()
                            .fill(index < progress ? .orange30 : .gray30)
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.vertical, 6)
            } else {
                Text("🍄")
                    .font(.h1)
            }
        }
    }
}

#Preview {
    @Previewable @State var dummyFriend: FriendResponse = FriendResponse(name: "", birthDay: "04/20", experienceDTO: .init(experiencePoint: 3, characterInfo: .init(imageURL: "")
        )
    )
    @Previewable @State var dummyFriend2: FriendResponse = FriendResponse(name: "", birthDay: "04/20", experienceDTO: .init(experiencePoint: 7, characterInfo: .init(imageURL: "")
        )
    )
    
    VStack {
        FriendInfoView(friendInfoData: dummyFriend)
            .frame(width: .infinity, height: 101)
        
        FriendInfoView(friendInfoData: dummyFriend2)
            .frame(width: .infinity, height: 101)
        
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray20.opacity(0.3))
}
