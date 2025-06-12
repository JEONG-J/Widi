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
    
    var isLoading: Bool = false
    
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
    
    /// 친구 삭제
    /// - Parameter friend: 친구 정보 입력
    @MainActor
    func deleteFriend() async {
        isLoading = true
        do {
            try await container.firebaseService.friends.deleteFriend(documentId: self.friendResponse.documentId)
            isLoading = false
        } catch {
            print("친구 삭제 실패: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    func returnFriendInfo() -> FriendRequest {
        return .init(name: friendResponse.name, birthday: friendResponse.birthday)
    }
    
    // MARK: - API
    
    func deleteDiary(_ diary: DiaryResponse) async {
        do {
            try await container.firebaseService.diary.deleteDiary(documentId: diary.documentId)
            diaries?.removeAll { $0.id == diary.id }
        } catch {
            print("일기 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchDiaries(for friend: FriendResponse) async {
        
        guard let userId = container.firebaseService.auth.currentUser?.uid else {
            print("로그인 유저 없음")
            return
        }
        
        do {
            let list = try await container.firebaseService.diary.fetchDiaries(
                for: userId,
                friendId: friend.friendId
            )
            self.diaries = list
        } catch {
            print("일기 조회 실패: \(error.localizedDescription)")
        }
    }
    
    func loadFriend(documentId: String) async {
        do {
            let friend = try await container.firebaseService.friends.fetchFriend(documentId: documentId)
            self.friendResponse = friend
        } catch {
            print("친구 정보 로드 실패: \(error.localizedDescription)")
        }
    }
}
