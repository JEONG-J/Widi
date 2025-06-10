//
//  NavigationRoutingView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import SwiftUI

struct NavigationRoutingView: View {
    
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        Group {
            switch destination {
            case .addFriendView:
                AddFriendView(container: container)
            case .addDiaryView(let friendsRequest):
                AddDiaryView(friendsRequest: friendsRequest, container: container)
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
