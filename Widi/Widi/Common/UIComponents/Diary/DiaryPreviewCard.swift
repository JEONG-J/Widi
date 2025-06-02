//
//  DiaryPreviewCard.swift
//  Widi
//
//  Created by jeongminji on 6/1/25.
//

import SwiftUI
import Kingfisher

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
        .frame(maxHeight: .infinity, alignment: .center)
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
            KFImage(url)
                .downsampling(size: .init(width: 400, height: 400))
                .cacheOriginalImage()
                .placeholder({
                    ProgressView()
                        .controlSize(.small)
                }).retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 86)
                .frame(maxHeight: .infinity)
                .clipped()
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var dummyDiaries: [DiaryResponse] = [
            DiaryResponse(
                id: UUID(),
                title: "학식당에서",
                content: "명상의 힘은 마음을 가라앉히고 내면의 평화를 찾는 방법을 제공합니다. 정기적인 명상은 스트레스를 줄이고 집중력을 향상시키는 방법입니다.",
                pictures:  ["https://i.namu.wiki/i/4HF0qDNbaYaUTHCyJJTMPJ9ADmbXdc4C6ahEqIxURdzOeBZqIxzY69Xu9EbP3qlX-kCCunsBwAZpSvccoHLiFGcdpbHaeBz2QpFDzVrAoc6PFvj_ieSeVQwvn-gMKveZAj-EtVaxqdf7G6Q2zSXDnw.webp"],
                diaryDate: "2025 / 05 / 24"
            ),
            DiaryResponse(
                id: UUID(),
                title: nil,
                content: "명상의 힘은 마음을 가라앉히고 내면의 평화를 찾는 방법을 제공합니다. 정기적인 명상은 스트레스를 줄이고 집중력을 향상시키는 방법입니다.",
                pictures: ["https://i.namu.wiki/i/yzxvPP2u3vcW4IpzOPGLEDn24IA_1V4nUGUy6hOaFGDQ5JH3mqVQyCnk4bZU4MZVzovE3AuHGeToAZIM7zCb_A.webp"],
                diaryDate: "2025 / 05 / 24"
            ),
            DiaryResponse(
                id: UUID(),
                title: nil,
                content: "명상의 힘은 마음을 가라앉히고 내면의 평화를 찾는 방법을 제공합니다. 정기적인 명상은 스트레스를 줄이고 집중력을 향상시키는 방법입니다.",
                pictures: nil,
                diaryDate: "2025 / 05 / 24"
            )
        ]
        
        var body: some View {
            List {
                ForEach(dummyDiaries) { diary in
                    VStack(spacing: 0) {
                        DiaryPreviewCard(
                            diaryData: diary
                        )
                        
                        Divider()
                            .background(Color.gray20)
                    }
                    .frame(height: 171)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .onTapGesture {
                        print("탭 \(diary.id)")
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(
                            action: { deleteDiary(diary)
                            }
                        ) {
                            Image(.delete)
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                        .tint(Color.red30)
                    }
                }
            }
            .listStyle(.plain)
        }
        
        private func deleteDiary(_ diary: DiaryResponse) {
            if let index = dummyDiaries.firstIndex(where: { $0.id == diary.id }) {
                dummyDiaries.remove(at: index)
            }
        }
    }
    return PreviewContainer()
}
