//
//  SelectedImagePreview.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI
import Kingfisher

/// 이미지 미리보기
struct SelectedImagePreview: View {
    
    // MARK: - Property
    
    let diaryImage: DiaryImage
    let onDelete: () -> Void
    let showDeleteButton: Bool
    let onSelect: (DiaryImage) -> Void
    
    // MARK: - Init
    
    /// 이미지 미리보기 초기화
    /// - Parameters:
    ///   - diaryImage: 사진 타입 설정
    ///   - onDelete: 삭제 액션
    ///   - showDeleteButton: 삭제 버튼 유무
    ///   - onSelect: 선택한 이미지 넘기기
    init(diaryImage: DiaryImage, onDelete: @escaping () -> Void, showDeleteButton: Bool, onSelect: @escaping (DiaryImage) -> Void) {
        self.diaryImage = diaryImage
        self.onDelete = onDelete
        self.showDeleteButton = showDeleteButton
        self.onSelect = onSelect
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topTrailing, content: {
            Button(action: {
                onSelect(diaryImage)
            }, label: {
                displayImage()
            })
            
            if showDeleteButton {
                Button(action: {
                    onDelete()
                }, label: {
                    Image(.closeX)
                        .background(Color.whiteBlack.opacity(0.6))
                        .clipShape(Circle())
                        .padding(8)
                })
            }
        })
    }
    
    /// 다이어리 이미지 타입에 따라 분리
    /// - Returns: 서버 및 로컬 이미지 분리
    private func displayImage() -> some View {
        Group {
            switch diaryImage {
            case .local(let image, _, _):
                image
                    .resizable()

            case .server(let string):
                KFImage(URL(string: string))
                    .placeholder {
                        ProgressView()
                            .controlSize(.regular)
                    }
                    .retry(maxCount: 2, interval: .seconds(2))
                    .cacheMemoryOnly()
                    .resizable()
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
