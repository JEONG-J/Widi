//
//  DetailFriendsViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import SwiftUI

@Observable
final class DetailFriendsViewModel {
    
    // MARK: - StatePropery
    var showFriendEdit: Bool = false
    var showDeleteAlert: Bool = false
    
    // MARK: - Property
    var diaries: [DiaryResponse]?
    var friendResponse: FriendResponse
    
    private var container: DIContainer
    
    // MARK: - Init
    
    init(container: DIContainer, friendResponse: FriendResponse) {
        self.container = container
        self.friendResponse = friendResponse
    }
    
    // MARK: - Method
    func deleteDiary(_ diary: DiaryResponse) {
        diaries?.removeAll { $0.id == diary.id }
    }
    
    func deleteFriend() async {
        print("hello")
    }
}
