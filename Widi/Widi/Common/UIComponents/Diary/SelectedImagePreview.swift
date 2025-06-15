//
//  SelectedImagePreview.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI
import Kingfisher

/// 선택한 이미지 작은 사이즈로 미리보기
struct SelectedImagePreview: View {
    
    // MARK: - Property
    let diaryImage: DiaryImage
    let onDelete: () -> Void
    let showDeleteButton: Bool
    let onSelect: (DiaryImage) -> Void
    
    // MARK: - Constants
    fileprivate enum SelectedImagePreviewConstants {
        static let conerRadius: CGFloat = 20
    }
    
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
                    withAnimation {
                        onDelete()
                    }
                }, label: {
                    Image(.closeX)
                        .background(Color.whiteBlack.opacity(0.6))
                        .clipShape(Circle())
                        .padding(NavigationIcon.closeX.paddingValue)
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
                            .tint(Color.orange30)
                    }
                    .retry(maxCount: 2, interval: .seconds(2))
                    .cacheMemoryOnly()
                    .resizable()
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: SelectedImagePreviewConstants.conerRadius))
    }
}

#Preview {
    SelectedImagePreview(diaryImage: .server("https://i.namu.wiki/i/A5TusY_zlof64PzVQDhxI57klv7a3bS5BSaKQ4uuuUYXxE_Jlich7fladJ9IfGwdIdGfu6CgLwDNIXa9MBrFEzMAGYmlzi36RQEeS-kAgpGAixJplNgNWr_j-MMn_0-OATgGTQUjbX8tiQi13ze5ZQ.webp"), onDelete: {}, showDeleteButton: true, onSelect: {_ in })
}
