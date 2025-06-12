//
//  DetailImageView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/5/25.
//

import SwiftUI
import Kingfisher

/// 이미지 원본 확인 뷰
struct DetailImageView: View {
    
    @Binding var images: [DiaryImage]
    @Binding var selectedImage: DiaryImage?
    @Environment(\.dismiss) var dismiss
    @State private var currentIndex: Int = 0
    
    let onDeleteServerImage: (String) -> Void
    let onDeleteLocalImage: (Int) -> Void
    
    var body: some View {
        ZStack(alignment: .center, content: {
            Color.white.ignoresSafeArea()
            
            middleContents
            
            VStack {
                topController
                
                Spacer()
                
                bottomPageController
            }
        })
        .task {
            if let selected = selectedImage,
               let index = images.firstIndex(of: selected) {
                currentIndex = index
            }
        }
        .onChange(of: currentIndex, { old, new in
            selectedImage = images[new]
        })
    }
    
    /// 상단 네비게이션
    private var topController: some View {
        CustomNavigation(config: .closeAndTrash, leftAction: { icon in
            switch icon {
            case .closeX:
                dismiss()
            default:
                break
            }
        }, rightAction: { icon in
            switch icon {
            case .trash:
                onDeleteAction()
                dismiss()
            default:
                break
            }
        })
        .safeAreaPadding(.horizontal, 16)
    }
    
    /// 중앙 사진 컨텐츠
    private var middleContents: some View {
        TabView(selection: $currentIndex, content: {
            ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                imageView(for: image)
                    .aspectRatio(contentMode: .fit)
                    .tag(index)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
        })
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    private var bottomPageController: some View {
        HStack {
            
            Spacer()
            
            PicturePageIndicator(numberOfPages: images.count, currentPage: $currentIndex)
            
            Spacer()
        }
        .frame(width: 393, height: 18)
    }
    
    @ViewBuilder
    private func imageView(for image: DiaryImage) -> some View {
        switch image {
        case .local(let image, _, _):
            image
                .resizable()
        case .server(let urlString):
            KFImage(URL(string: urlString))
                .placeholder {
                    ProgressView()
                }
                .resizable()
        }
    }
    
    private func onDeleteAction() {
        guard let selected = selectedImage else { return }

        if case let .server(urlString) = selected {
            onDeleteServerImage(urlString)
        }

        if let index = images.firstIndex(of: selected) {
            if case .local = selected {
                onDeleteLocalImage(index)
            }

            images.remove(at: index)

            if currentIndex >= images.count {
                currentIndex = max(0, images.count - 1)
            }
        }
    }
}
