//
//  DiaryPreviewCard.swift
//  Widi
//
//  Created by jeongminji on 6/1/25.
//

import SwiftUI
import Kingfisher

/// 일기 카드 컴포넌트
struct DiaryPreviewCard: View {
    
    // MARK: - Propertity
    
    private let diaryData: DiaryResponse
    
    // MARK: - Init
    
    /// DiaryPreviewCard
    /// - Parameter diaryData: DiaryResponse
    init(diaryData: DiaryResponse) {
        self.diaryData = diaryData
    }
    
    // - MARK: Body
    
    var body: some View {
        HStack(spacing: 16) {
            diaryTextContent
            diaryImage
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 28)
        .frame(maxHeight: .infinity, alignment: .top)
        .contentShape(Rectangle()) // 터치 영역을 HStack 전체로 확장
    }
    
    var diaryTextContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title = diaryData.title {
                Text(title)
                    .lineLimit(1)
                    .font(.h3)
                    .foregroundStyle(.gray80)
                    .padding(.bottom, 4)
            }
            
            Text(diaryData.content.customLineBreak())
                .lineLimit(diaryData.title == nil ? 3 : 2)
                .lineSpacing(1.6)
                .multilineTextAlignment(.leading)
                .font(.b1)
                .foregroundStyle(.gray80)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            
            Text(diaryData.diaryDate)
                .font(.b2)
                .foregroundStyle(.gray40)
        }
    }
    
    /// 일기 이미지 캐시 처리
    @ViewBuilder
    private var diaryImage: some View {
        if let urlString = diaryData.pictures?.first,
           let url = URL(string: urlString) {
            
            ZStack(alignment: .topTrailing) {
                KFImage(url)
                    .downsampling(size: .init(width: 400, height: 400))
                    .cacheOriginalImage()
                    .placeholder {
                        ProgressView()
                            .controlSize(.regular)
                    }
                    .retry(maxCount: 2, interval: .seconds(2))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 86)
                    .frame(maxHeight: .infinity)
                    .clipped()
                
                if let pictures = diaryData.pictures, pictures.count > 1 {
                    Image(.image)
                        .resizable()
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 2)
                        .padding(.top, 4)
                }
            }
        }
    }
}
