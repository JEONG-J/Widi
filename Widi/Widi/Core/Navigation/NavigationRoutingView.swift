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
            case .addDiaryView(let friendsRequest, let firstMode):
                AddDiaryView(friendsRequest: friendsRequest, container: container, firstMode: firstMode)
            case .detailFriendView(let friendResponse):
                DetailFriendsView(container: container, friendResponse: friendResponse)
            case .detailDiaryView(let name, let mode):
                DetailDiaryScreenvView(friendName: name, diaryMode: mode, container: container)
            case .searchDiary(let friendResponse):
                SearchDiaryView(container: container, friendResponse: friendResponse)
            case .myPage:
                MyPageView(container: container)
            }
        }
        .environmentObject(container)
    }
}
