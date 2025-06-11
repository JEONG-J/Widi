//
//  DetailFriendsViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import SwiftUI

/// 친구 상세 뷰모델
@Observable
final class DetailFriendsViewModel {
    
    // MARK: - StatePropery
    var showFriendEdit: Bool = false
    var showFriendDeleteAlert: Bool = false
    var showDiaryDeleteAlert: Bool = false
    
    // MARK: - Property
    var diaries: [DiaryResponse]? = [
        .init(content: "dmdkdkdkkdkdkddkdkdk", diaryDate: "11")
    ]
    var friendResponse: FriendResponse
    
    private var container: DIContainer
    
    // MARK: - Init
    
    init(container: DIContainer, friendResponse: FriendResponse) {
        self.container = container
        self.friendResponse = friendResponse
    }
    
    // MARK: - Method
    func deleteDiary(_ diary: DiaryResponse) async {
        print("다이어리 삭제함")
        diaries?.removeAll { $0.id == diary.id }
    }
    
    func deleteFriend() async {
        print("hello")
    }
    
    func returnFriendInfo() -> FriendRequest {
        return .init(name: friendResponse.name, birthDay: friendResponse.birthDay)
    }
    
    // MARK: - API
    func deleteDiaryAPI() async {
        print("Hello")
    }
}
