//
//  CreateDiaryViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import Foundation
import PhotosUI
import SwiftUI

@Observable
class CreateDiaryViewModel: DiaryViewModelProtocol {
    // MARK: - StateProperty
    var isShowCalendar: Bool = false
    var isShowImagePicker: Bool = false
    
    // MARK: - CreateFriend
    var friendsRequest: FriendRequest
    
    init(friendRequest: FriendRequest) {
        self.friendsRequest = friendRequest
    }
    
    // MARK: - DiaryProtocol
    var diary: DiaryRequest? = nil
    var diaryMode: DiaryMode = .write
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
    public func addFriendsAndDiary() {
        print("완료")
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
    
    // MARK: - API
    
}
