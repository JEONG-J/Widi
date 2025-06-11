//
//  NavigationRoutingView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import SwiftUI

/// NavigationDestination에 따라 해당 화면을 렌더링하는 라우팅 전용 뷰
struct NavigationRoutingView: View {
    
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        Group {
            switch destination {
            case .addFriendView:
                AddFriendView(container: container)
            case .addDiaryView(let friendsRequest, let firstMode):
                AddDiaryView(friendsRequest: friendsRequest, container: container, firstMode: firstMode)
            case .detailFriendView(let friendResponse):
                DetailFriendsView(container: container, friendResponse: friendResponse)
            case .searchDiary:
                SearchDiaryView(container: container)
            case .myPage:
                MyPageView(container: container)
            }
        }
        .environmentObject(container)
    }
}
