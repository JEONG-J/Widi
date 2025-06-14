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
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @State var destination: NavigationDestination
    
    var body: some View {
        Group {
            switch destination {
            case .addFriendView:
                AddFriendView(container: container)
            case .addDiaryView(let friendsRequest, let firstMode, let friendId):
                AddDiaryView(friendsRequest: friendsRequest, container: container, firstMode: firstMode, friendId: friendId)
            case .detailFriendView(let friendResponse):
                DetailFriendsView(container: container, friendResponse: friendResponse)
            case .detailDiaryView(let name, let mode, let diaryResponse):
                DetailDiaryScreenvView(friendName: name, diaryMode: mode, container: container, diaryResponse: diaryResponse)
            case .searchDiary(let friendResponse):
                SearchDiaryView(container: container, friendResponse: friendResponse)
            case .myPage:
                MyPageView(container: container, appFlowViewModel: appFlowViewModel)
                    .environmentObject(appFlowViewModel)
            }
        }
        .environmentObject(container)
    }
}
