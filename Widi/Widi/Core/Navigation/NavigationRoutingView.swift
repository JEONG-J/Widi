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
        switch destination {
        case .addFriendView:
            AddFriendView()
            // TODO: - 일기 추가 뷰로 ㅅ정
        case .addDiaryView:
            ContentView()
        case .detailDiaryView:
            DetailDiaryView()
    }
}
