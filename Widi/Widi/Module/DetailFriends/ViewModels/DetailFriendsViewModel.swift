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
    /// 친구 편집
    var showFriendEdit: Bool = false
    /// 친구 삭제 Alert
    var showFriendDeleteAlert: Bool = false
    /// 일기 삭제 Alert
    var showDiaryDeleteAlert: Bool = false
    /// 삭제 로딩
    var deleteLoading: Bool = false
    /// 친구 일기 데이터 불러오기 로딩
    var diaryInfoLoading: Bool = false
    /// 상단 드롭 다운 메뉴 표시
    var isDropDownPresented: Bool = false
    /// 친구 정보 로딩 표시
    var isFriendInfoLoading: Bool = false
    
    // MARK: - Property
    var diaries: [DiaryResponse]?
    var friendResponse: FriendResponse
    var targetDiary: DiaryResponse? = nil
    
    private var container: DIContainer
    
    // MARK: - Init
    
    init(container: DIContainer, friendResponse: FriendResponse) {
        self.container = container
        self.friendResponse = friendResponse
    }
    
    // MARK: - API
    
    /// 친구 삭제
    @MainActor
    func deleteFriend() async {
        deleteLoading = true
        
        guard let documentId = friendResponse.documentId else {
            print("documentId가 nil입니다. 친구를 삭제할 수 없습니다.")
            deleteLoading = false
            return
        }
        
        do {
            try await container.firebaseService.friends.deleteFriend(documentId: documentId)
            print("친구 삭제 성공")
        } catch {
            print("친구 삭제 실패: \(error.localizedDescription)")
        }
        
        deleteLoading = false
    }
    
    func returnFriendInfo() -> FriendRequest {
        return .init(name: friendResponse.name, birthday: friendResponse.birthday)
    }
    
    /// 일기 삭제
    func deleteDiary(_ diary: DiaryResponse) async {
        guard let documentId = diary.documentId else {
            print("documentId가 nil입니다. 일기를 삭제할 수 없습니다.")
            return
        }
        
        do {
            try await container.firebaseService.diary.deleteDiary(documentId: documentId)
            diaries?.removeAll { $0.id == diary.id }
            print("일기 삭제 성공")
        } catch {
            print("일기 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchDiaries(for friend: FriendResponse) async {
        diaryInfoLoading = true
        
        guard let userId = container.firebaseService.auth.currentUser?.uid else {
            print("로그인 유저 없음")
            diaryInfoLoading = false
            return
        }
        do {
            let list = try await container.firebaseService.diary.fetchDiaries(
                for: userId,
                friendId: friend.friendId
            )
            self.diaries = list
            diaryInfoLoading = false
        } catch {
            print("일기 조회 실패: \(error.localizedDescription)")
            diaryInfoLoading = false
        }
    }
    
    func loadFriend(documentId: String) async {
        isFriendInfoLoading = true
        do {
            let friend = try await container.firebaseService.friends.fetchFriend(documentId: documentId)
            self.friendResponse = friend
            isFriendInfoLoading = false
        } catch {
            print("친구 정보 로드 실패: \(error.localizedDescription)")
            isFriendInfoLoading = false
        }
    }
}
