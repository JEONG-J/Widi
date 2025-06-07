//
//  DetailImageView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/5/25.
//

import SwiftUI
import Kingfisher

struct DetailImageView: View {
    
    @Binding var images: [DiaryImage]
    @Binding var selectedImage: DiaryImage
    @EnvironmentObject var container: DIContainer
    @State private var currentIndex: Int = 0
    
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
            if let index = images.firstIndex(of: selectedImage ) {
                self.currentIndex = index
            }
        }
        .onChange(of: currentIndex, { old, new in
            selectedImage = images[new]
            print(selectedImage)
        })
    }
    
    /// 상단 네비게이션
    private var topController: some View {
        CustomNavigation(config: .closeAndTrash, leftAction: { icon in
            switch icon {
            case .backArrow:
                container.navigationRouter.pop()
            default:
                break
            }
        }, rightAction: { icon in
            switch icon {
            case .trash:
                print("hello")
                container.navigationRouter.pop()
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
        case .local(let image, _):
            image.resizable()
        case .server(let urlString):
            KFImage(URL(string: urlString))
                .placeholder {
                    ProgressView()
                }
                .resizable()
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var images: [DiaryImage] = [
            .server("https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F9942DC435BBAE4F519"),
            .server("https://i.namu.wiki/i/kzT_tE56t34FjtR-T-tenozR1ONGj384QE1QF5to_FFtQO-xtlm6tsiZb9pRhOOLCgZNY_nmccpgAj2G0ESgaXUnOIB3OeBObmeMCyniiX0t538zLkNBkkoZh32LmIFUcASMd6LF1ruEbN673vcjmg.webp")
        ]
        @State private var selectedImage: DiaryImage = .server("https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F9942DC435BBAE4F519")
        
        var body: some View {
            DetailImageView(images: $images, selectedImage: $selectedImage)
                .environmentObject(DIContainer())
        }
    }

    return PreviewWrapper()
}
