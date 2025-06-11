//
//  DetailDiaryViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation
import PhotosUI
import SwiftUI

@Observable
class DetailDiaryViewModel: DiaryViewModelProtocol, CalendarControllable {
    
    
    
    // MARK: - StateProperty
    var isShowStopEditAlert: Bool = false
    var isShowDeleteDiaryAlert: Bool = false
    var isShowCalendar: Bool = false
    var isShowImagePicker: Bool = false
    
    // MARK: - Property
    var diary: DiaryResponse? {
        didSet {
            guard let diary = diary else { return }
            diaryTitle = diary.title ?? ""
            diaryContents = diary.content
        }
    }
    
    var dateString: String = ""
    
    var diaryImages: [DiaryImage] = [.server("https://i.namu.wiki/i/MNpePzeeKAtd-rcjEzYfCKiGwYnwG1gyAQxjmx1lSCKZBnYd1zd5vwwVcvJsvc1fr3ipMmlja55Qwq41GDj4BvmvnGQsey8YP3T2IPpzxNdWv8itxjsAybCeqartv5kp8SeXGexnFT53BwkQY8XXmQ.webp")]
    var photoImages: [PhotosPickerItem] = []
    var selectedImage: DiaryImage? = nil
    
    var diaryMode: DiaryMode
    private var container: DIContainer
    
    var diaryTitle: String = ""
    var diaryContents: String = ""
    
    // MARK: - Init
    init(diaryMode: DiaryMode, container: DIContainer) {
        self.diaryMode = diaryMode
        self.container = container
    }
    
    // MARK: - Read
    /// 일기 삭제
    func deleteDiary() async {
        print("일기 삭제")
    }
    
    // MARK: - Write
    
    /// 수정 완료 함수
    func saveEditContent() async {
        print("hello")
    }
    
    /// 이미지 삭제
    /// - Parameter index: 이미지 삭제 인덱스
    func deleteImage(index: Int) {
        guard diaryImages.indices.contains(index) else { return }
        
        let image = diaryImages[index]
        
        switch image {
        case .local:
            if let targetIndex = photoImages.firstIndex(where: { item in
                return diaryImages[index].id == image.id
            }) {
                photoImages.remove(at: targetIndex)
            }

        case .server(let url):
            print("서버 이미지 삭제: \(url)")
        }
        
        diaryImages.remove(at: index)
    }
    
    @MainActor
    func convertSelectedPhotosToUIImage() async {
        let currentLocalCount = diaryImages.filter {
            if case .local = $0 { return true }
            return false
        }.count

        let newItems = photoImages.dropFirst(currentLocalCount)

        for item in newItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                let swiftUIImage = Image(uiImage: image)
                diaryImages.append(.local(swiftUIImage))
            }
        }
    }
}
