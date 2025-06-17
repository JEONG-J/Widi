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
    
    // MARK: - Property
    @Binding var images: [DiaryImage]
    @Binding var selectedImage: DiaryImage?
    @Environment(\.dismiss) var dismiss
    @State private var currentIndex: Int = 0
    
    let onDeleteServerImage: (String) -> Void
    let onDeleteLocalImage: (Int) -> Void
    
    // MARK: - Constants
    fileprivate enum DetailImageViewConstants {
        static let bottomPageControllerFrame: (CGFloat, CGFloat) = (393, 18)
    }
    
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
        .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
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
    
    /// 하단 바텀 페이지 컨트롤러
    private var bottomPageController: some View {
        HStack {
            Spacer()
            
            PicturePageIndicator(numberOfPages: images.count, currentPage: $currentIndex)
            
            Spacer()
        }
        .frame(width: DetailImageViewConstants.bottomPageControllerFrame.0, height: DetailImageViewConstants.bottomPageControllerFrame.1)
    }
    
    /// 이미지 우너본
    /// - Parameter image: 저장된 이미지
    /// - Returns: 뷰로 반환
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
    
    /// 서버 또는 로컬 경우에 대해 이미지 삭제
    private func onDeleteAction() {
        guard let selected = selectedImage else { return }
        
        guard let index = images.firstIndex(of: selected) else { return }
        
        if case let .server(urlString) = selected {
            onDeleteServerImage(urlString)
        } else {
            onDeleteLocalImage(index)
        }
        
        images.remove(at: index)
        
        currentIndex = min(currentIndex, max(0, images.count - 1))
        
        if images.indices.contains(currentIndex) {
            selectedImage = images[currentIndex]
        } else {
            selectedImage = nil
        }
    }
}
