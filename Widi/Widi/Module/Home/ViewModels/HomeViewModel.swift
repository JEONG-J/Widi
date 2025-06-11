//
//  HomeViewModels.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation

/// 홈 뷰모델
@Observable
class HomeViewModel {
    var friendsData: [FriendResponse]?
    
    var container: DIContainer
    var isLoading: Bool = false
    
    
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - API
    func getMyFriends() async {
        isLoading = true
        
        guard let userId = container.firebaseService.auth.currentUser?.uid else {
            print("로그인 유저 없음")
            isLoading = false
            return
        }
        
        do {
            let friends = try await container.firebaseService.friends.fetchFriends(for: userId)
            self.friendsData = friends
            isLoading = false
            print("친구 데이터 조회: \(friends.count)")
        } catch {
            print("친구 불러오기 실패:", error.localizedDescription)
        }
    }
}
