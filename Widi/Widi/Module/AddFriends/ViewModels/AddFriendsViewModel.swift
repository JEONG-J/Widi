//
//  AddFriendsViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import Foundation
import PhotosUI
import SwiftUI

@Observable
class AddFriendsViewModel {
    
    // MARK: - StateProperty
    var currentPage: Int = 1
    var isShowCalendar: Bool = false
    var isShowImagePicker: Bool = false
    
    // MARK: - Friends
    var friendsName: String = ""
    var friendsBirthDay: String = ""
    
    // MARK: - Diary
    var dateString: String = ""
    var diaryTitle: String = ""
    var diaryContents: String = "" {
        didSet {
            diaryIsEmphasized = !diaryContents.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    var diaryIsEmphasized: Bool = false
    var photoImages: [PhotosPickerItem] = []
    var diaryImages: [DiaryImage] = []
    
    // MARK: - Function
    /// 일기 작성 후 생성 버튼 액션
    public func addFriendsAndDiary() {
        print("완료")
    }
    
    /// 현재 날짜 데이터 가져오기
    /// - Returns: 오늘 날짜 년 월 일 가져오기
    func simpleDateString(from date: Date) {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date) % 100
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        self.dateString = "\(year)년 \(month)월 \(day)일"
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
