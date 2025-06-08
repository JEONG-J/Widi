//
//  DiaryImageScrollView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import SwiftUI

struct DiaryImageScrollView: View {
    let images: [DiaryImage]
    let mode: DiaryMode
    let onDelete: (DiaryImage) -> Void
    
    
    init(images: [DiaryImage], mode: DiaryMode, onDelete: @escaping (DiaryImage) -> Void) {
        self.images = images
        self.mode = mode
        self.onDelete = onDelete
    }
    
    var body: some View {
        ScrollView(.horizontal, content: {
            LazyHStack(spacing: 6, content: {
                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                    SelectedImagePreview(diaryImage: image,
                                         onDelete: { onDelete(image) },
                                         showDeleteButton: mode != .read)
                }
            })
        })
        .frame(height: 132)
        .contentMargins(.horizontal, 16)
        .contentMargins(.bottom, 8)
    }
}
