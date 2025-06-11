//
//  CreateDiaryViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import Foundation
import PhotosUI
import SwiftUI

/// 일기 작성 뷰모델
@Observable
class CreateDiaryViewModel: DiaryViewModelProtocol, CalendarControllable {
    
    // MARK: - StateProperty
    var isShowCalendar: Bool = false
    var isShowImagePicker: Bool = false
    var checkBackView: Bool = false
    var isLoading: Bool = false
    
    // MARK: - CreateFriend
    var friendsRequest: FriendRequest
    let container: DIContainer
    
    init(friendRequest: FriendRequest, container: DIContainer) {
        self.friendsRequest = friendRequest
        self.container = container
    }
    
    // MARK: - DiaryProtocol
    var diary: DiaryRequest? = nil
    var diaryImages: [DiaryImage] = []
    var selectedImage: DiaryImage? = nil
    
    // MARK: - Property
    var dateString: String = ""
    var diaryTitle: String = ""
    var diaryContents: String = "" {
        didSet {
            diaryIsEmphasized = !diaryContents.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    var diaryIsEmphasized: Bool = false
    var photoImages: [PhotosPickerItem] = []
    
    // MARK: - Function
    /// 일기 작성 후 생성 버튼 액션
    public func addFriends() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let userId = container.firebaseService.auth.currentUser?.uid else {
            print("로그인 사용자 없음")
            return
        }
        do {
            let friendId = try await container.firebaseService.friends.addFriend(userId: userId, request: friendsRequest)
            await addDiary(targetFriendId: friendId)
        } catch {
            print("친구 추가 실패: \(error.localizedDescription)")
        }
        
    }
    
    public func addDiary(targetFriendId: String) async {
        guard let userId = container.firebaseService.auth.currentUser?.uid else {
                print("로그인 정보 없음")
                return
            }
            
            do {
                try await container.firebaseService.diary.addDiary(
                    userId: userId,
                    friendId: targetFriendId,
                    title: diaryTitle.isEmpty ? nil : diaryTitle,
                    content: diaryContents,
                    images: diaryImages,
                    diaryDate: dateString
                )
                print("일기 등록 완료")
                isLoading = false
            } catch {
                print("일기 등록 실패: \(error.localizedDescription)")
            }
    }
    
    /// 앨범에서 가져온 경우만 이미지 변환하기
    @MainActor
    func convertSelectedPhotosToUIImage() async {
        
        let currentCount = diaryImages.count
        let newItems = photoImages.dropFirst(currentCount)
        
        for item in newItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                let swiftUIImage = Image(uiImage: image)
                diaryImages.append(.local(swiftUIImage))
            }
        }
    }
}
