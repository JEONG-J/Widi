//
//  DetailDiaryViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation
import PhotosUI
import SwiftUI

/// 일기 상세 뷰모델
@Observable
class DetailDiaryViewModel: DiaryViewModelProtocol, CalendarControllable {
    
    // MARK: - StateProperty
    var isShowStopEditAlert: Bool = false
    var isShowDeleteDiaryAlert: Bool = false
    var isShowCalendar: Bool = false
    var isShowImagePicker: Bool = false
    var isEditLoading: Bool = false
    
    // MARK: - Property
    var diary: DiaryResponse? {
        didSet {
            guard let diary = diary else { return }
            diaryTitle = diary.title ?? ""
            diaryContents = diary.content
        }
    }
    
    var dateString: String = ""
    
    var diaryImages: [DiaryImage] = []
    var photoImages: [PhotosPickerItem] = []
    var selectedImage: DiaryImage? = nil
    
    var diaryMode: DiaryMode
    private var container: DIContainer
    
    var diaryTitle: String = ""
    var diaryContents: String = ""
    
    // MARK: - Init
    init(diaryMode: DiaryMode, container: DIContainer, diary: DiaryResponse) {
        self.diaryMode = diaryMode
        self.container = container
        self.diary = diary
        
        if let pictures = diary.pictures {
            self.diaryImages = pictures.map { DiaryImage.server($0) }
        } else {
            self.diaryImages = []
        }
    }
    
    // MARK: - Read
    /// 일기 삭제
    
    func deleteDiary() async {
        self.isEditLoading = true
        if let diary = diary {
            do {
                try await container.firebaseService.diary.deleteDiary(documentId: diary.documentId)
            } catch {
                print("일기 삭제 실패: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
    
    
    // MARK: - Write
    
    /// 수정 완료 함수
    @MainActor
    func saveEditContent() async {
        isEditLoading = true
        
        guard let diary = diary else { return }
        
        do {
            try await container.firebaseService.diary.updateDiaryWithImages(
                diaryId: diary.documentId,
                title: diaryTitle.isEmpty ? nil : diaryTitle,
                content: diaryContents,
                images: diaryImages,
                originalServerImageURLs: diary.pictures ?? [],
                diaryDate: dateString
            )
            print("일기 수정 성공")
        } catch {
            print("일기 수정 실패: \(error.localizedDescription)")
            isLoading = false
        }
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
    func deleteServerImage(url: String) async {
        if let diary = diary {
            let diaryId = diary.documentId
            do {
                try await container.firebaseService.diary.deleteImage(from: diaryId, imageUrl: url)
            } catch {
                print("이미지 삭제 실패: \(error.localizedDescription)")
            }
        }
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
