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

#Preview {
    DiaryImageScrollView(images: [
        .server("https://i.namu.wiki/i/A5TusY_zlof64PzVQDhxI57klv7a3bS5BSaKQ4uuuUYXxE_Jlich7fladJ9IfGwdIdGfu6CgLwDNIXa9MBrFEzMAGYmlzi36RQEeS-kAgpGAixJplNgNWr_j-MMn_0-OATgGTQUjbX8tiQi13ze5ZQ.webp"),
        .server("https://i.namu.wiki/i/AY0dcJwDyaiUcP2mjo0oRJludww2a9vRnZOXoAfJXF6_d8dinmbbwop4Wjdk7fR12mPKEfQWfQ0vqbqgoHbZmEDDdVaty7HJ3-4-LYlWhAOVBaG6v1gLvuIlbW15tVF4SAXnCvVeZXwYsw88JiRmfw.webp")
    ], mode: .read, onDelete: {_ in }, onSelect: {_ in})
}
