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
        case .addDiaryView:
            Text("12")
        case .detailDiaryView:
            Text("11")
        }
    }
}
