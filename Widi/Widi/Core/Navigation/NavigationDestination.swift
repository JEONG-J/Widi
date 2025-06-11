//
//  NavigationDestination.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation

/// 화면 이동을 위한 네비게이션 목적지를 정의한 열거형
enum NavigationDestination: Equatable, Hashable {
    case addFriendView
    case addDiaryView(friendsRequest: FriendRequest, firstMode: Bool)
    case detailFriendView(friendResponse: FriendResponse)
    case searchDiary
    case myPage
}
