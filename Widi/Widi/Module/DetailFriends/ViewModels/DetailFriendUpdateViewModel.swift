//
//  DetailFirendUpdateViewModel.swift
//  Widi
//
//  Created by Miru on 2025/6/5.
//

import Foundation

/// 친구 수정 뷰모델
@Observable
class DetailFriendUpdateViewModel {
    
    // MARK: - Property
    var nameText: String = ""
    var birthdayText: String = ""
    var friendResponse: FriendResponse
    
    private var container: DIContainer
    
    init(container: DIContainer, friendResponse: FriendResponse) {
        self.container = container
        self.nameText = friendResponse.name
        self.birthdayText = friendResponse.birthday ?? ""
        self.friendResponse = friendResponse
    }
    
    @MainActor
    func updateFriend() async {
        do {
            try await container.firebaseService.friends.updateFriendInfo(
                documentId: friendResponse.documentId,
                name: nameText,
                birthday: birthdayText.isEmpty ? nil : birthdayText
            )
        } catch {
            print("친구 정보 수정 실패: \(error.localizedDescription)")
        }
    }
    
    func returnOutsize() -> FriendResponse {
        return .init(documentId: friendResponse.documentId, friendId: friendResponse.friendId, name: nameText, birthday: birthdayText, experienceDTO: friendResponse.experienceDTO)
    }
}
