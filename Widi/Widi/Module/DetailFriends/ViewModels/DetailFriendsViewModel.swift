//
//  DetailFriendsViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import SwiftUI

@Observable
final class DetailFriendsViewModel {
    
    // MARK: - Property
    
    private(set) var diaries: [DiaryResponse]
    private(set) var friendData: FriendResponse
    
    // MARK: - Init
    
    /// DetailFriendsViewModel
    /// - Parameters:
    ///   - friendData: FriendResponse
    ///   - diaries: DiaryResponse 리스트
    init(friendData: FriendResponse, diaries: [DiaryResponse]) {
        self.friendData = friendData
        self.diaries = diaries
    }
    
    // MARK: - Method
    
    func deleteDiary(_ diary: DiaryResponse) {
        diaries.removeAll { $0.id == diary.id }
    }
}
