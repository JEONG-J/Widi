//
//  DiaryImageScrollView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import SwiftUI

/// 일기 이미지 가로 스크롤 뷰
struct DiaryImageScrollView: View {
    
    // MARK: - Property
    let images: [DiaryImage]
    let mode: DiaryMode
    let onDelete: (Int) -> Void
    let onSelect: (DiaryImage) -> Void
    
    // MARK: - Constants
    fileprivate enum DiaryImageScrollConstants {
        static let lazyHStackSpacing: CGFloat = 6
        static let lazyHStackFrame: CGFloat = 132
        static let lazyHStackBottomMargins: CGFloat = 8
    }
    
    // MARK: - Init
    init(
        images: [DiaryImage],
        mode: DiaryMode,
        onDelete: @escaping (Int) -> Void,
        onSelect: @escaping (DiaryImage) -> Void
    ) {
        self.images = images
        self.mode = mode
        self.onDelete = onDelete
        self.onSelect = onSelect
    }
    
    var body: some View {
        ScrollView(.horizontal, content: {
            LazyHStack(spacing: DiaryImageScrollConstants.lazyHStackSpacing, content: {
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
        .frame(height: DiaryImageScrollConstants.lazyHStackFrame)
        .contentMargins(.horizontal, UIConstants.defaultHorizontalPadding)
        .contentMargins([.bottom, .top], DiaryImageScrollConstants.lazyHStackBottomMargins)
    }
}

#Preview {
    DiaryImageScrollView(images: [
        .server("https://i.namu.wiki/i/A5TusY_zlof64PzVQDhxI57klv7a3bS5BSaKQ4uuuUYXxE_Jlich7fladJ9IfGwdIdGfu6CgLwDNIXa9MBrFEzMAGYmlzi36RQEeS-kAgpGAixJplNgNWr_j-MMn_0-OATgGTQUjbX8tiQi13ze5ZQ.webp"),
        .server("https://i.namu.wiki/i/AY0dcJwDyaiUcP2mjo0oRJludww2a9vRnZOXoAfJXF6_d8dinmbbwop4Wjdk7fR12mPKEfQWfQ0vqbqgoHbZmEDDdVaty7HJ3-4-LYlWhAOVBaG6v1gLvuIlbW15tVF4SAXnCvVeZXwYsw88JiRmfw.webp")
    ], mode: .edit, onDelete: {_ in }, onSelect: {_ in})
}
