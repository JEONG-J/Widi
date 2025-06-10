//
//  NavigationDestination.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation

enum NavigationDestination: Equatable, Hashable {
    case addFriendView
    case addDiaryView(friendsRequest: FriendRequest, firstMode: Bool)
    case detailFriendView(friendResponse: FriendResponse)
    case searchDiary
    case myPage
}
