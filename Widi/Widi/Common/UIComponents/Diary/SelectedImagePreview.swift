//
//  SelectedImagePreview.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI
import Kingfisher

struct SelectedImagePreview: View {
    
    // MARK: - Property
    
    let diaryImage: DiaryImage
    let onDelete: () -> Void
    
    @State var showFullImage: Bool
    
    // MARK: - Init
    
    init(diaryImage: DiaryImage, onDelete: @escaping () -> Void, showFullImage: Bool = false) {
        self.diaryImage = diaryImage
        self.onDelete = onDelete
        self.showFullImage = showFullImage
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topTrailing, content: {
            Button(action: {
                showFullImage.toggle()
            }, label: {
                displayImage()
            })
            
            Button(action: {
                onDelete()
            }, label: {
                Image(.closeX)
                    .background(Color.whiteBlack.opacity(0.6))
                    .clipShape(Circle())
                    .padding(8)
            })
        })
        // TODO: - 풀스크린 이미지 뷰 만들기
        .fullScreenCover(isPresented: $showFullImage, content: {
            Text("풀 스크린 이미지 뷰 등장하기")
        })
    }
    
    private func displayImage() -> some View {
        Group {
            switch diaryImage {
            case .local(let image):
                image
                    .resizable()
            case .server(let string):
                KFImage(URL(string: string))
                    .placeholder {
                        ProgressView()
                            .controlSize(.regular)
                    }.retry(maxCount: 2, interval: .seconds(2))
                    .cacheMemoryOnly()
                    .resizable()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 132)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
