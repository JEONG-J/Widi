//
//  AddFriendsViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import Foundation
import PhotosUI
import SwiftUI

/// 친구 추가 뷰모델
@Observable
class AddFriendsViewModel {
    
    // MARK: - StateProperty
    var currentPage: Int = 1
    
    var friendsName: String = ""
    var friendsBirthDay: String = ""
    
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Func
    private func createFriendRequest() -> FriendRequest {
        return FriendRequest(name: friendsName, birthDay: friendsBirthDay)
    }
    
    public func navigationPush() {
        container.navigationRouter.push(to: .addDiaryView(friendsRequest: createFriendRequest(), firstMode: true))
    }
}
