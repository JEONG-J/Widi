//
//  DiaryImageScrollView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import SwiftUI

/// 일기 이미지 가로 스크롤 뷰
struct DiaryImageScrollView: View {
    let images: [DiaryImage]
    let mode: DiaryMode
    let onDelete: (Int) -> Void
    let onSelect: (DiaryImage) -> Void
    
    var body: some View {
        ScrollView(.horizontal, content: {
            LazyHStack(spacing: 6, content: {
                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                    SelectedImagePreview(diaryImage: image,
                                         onDelete: { onDelete(index) },
                                         showDeleteButton: mode != .read,
                                         onSelect: { image in
                        onSelect(image)
                    })
                }
            })
        })
        .frame(height: 132)
        .contentMargins(.horizontal, 16)
        .contentMargins(.bottom, 8)
    }
}
