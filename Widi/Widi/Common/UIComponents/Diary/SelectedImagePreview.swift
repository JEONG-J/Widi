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
    
    /// 이미지 미리보기 초기화
    /// - Parameters:
    ///   - diaryImage: 사진 타입 설정
    ///   - onDelete: 삭제 액션
    ///   - showFullImage: 이미 상세 화면 보이기
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
    
    /// 다이어리 이미지 타입에 따라 분리
    /// - Returns: 서버 및 로컬 이미지 분리
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
        .aspectRatio(1, contentMode: .fill)
        .frame(maxWidth: 132, maxHeight: 132)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .border(Color.red)
    }
}

#Preview {
    HStack {
        SelectedImagePreview(diaryImage: .server("https://i.namu.wiki/i/4HF0qDNbaYaUTHCyJJTMPJ9ADmbXdc4C6ahEqIxURdzOeBZqIxzY69Xu9EbP3qlX-kCCunsBwAZpSvccoHLiFGcdpbHaeBz2QpFDzVrAoc6PFvj_ieSeVQwvn-gMKveZAj-EtVaxqdf7G6Q2zSXDnw.webp"), onDelete: {
            print("hello")
        }, showFullImage: false)
    }
    .safeAreaPadding(.horizontal, 16)
    .frame(height: 132)
}
