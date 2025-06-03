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
    
    var actionSheetButtons: [ActionSheetButton] {
        [
            ActionSheetButton(
                title: "일기 검색하기",
                action: { self.searchDiary() }
            ),
            ActionSheetButton(
                title: "친구 수정하기",
                action: { self.editFriend() }
            ),
            ActionSheetButton(
                title: "친구 삭제하기",
                role: .destructive,
                action: { self.deleteFriend() }
            )
        ]
    }
    
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
    
    // TODO: - 바텀시트 등장
    func searchDiary() {
        print("일기 검색 화면")
    }
    
    // TODO: - 네비게이션 연결
    func editFriend() {
        print("친구 수정 화면")
    }
    
    // TODO: - 서버 호출 및 네비게이션 연결
    func deleteFriend() {
        print("친구 삭제 후 뒤로가기")
    }
}
