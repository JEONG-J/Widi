//
//  DiaryPreviewCard.swift
//  Widi
//
//  Created by jeongminji on 6/1/25.
//

import SwiftUI

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
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let title = diaryData.title {
                        Text(title)
                            .lineLimit(1)
                            .font(.h3)
                            .foregroundStyle(.gray80)
                    }
                    
                    Text(trimmedContent(diaryData.content).customLineBreak())
                        .lineLimit(diaryData.title == nil ? 3 : 2)
                        .font(.b1)
                        .foregroundStyle(.gray80)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 12)
                    
                    Text(diaryData.diaryDate)
                        .font(.b2)
                        .foregroundStyle(.gray40)
                }
                
                if let firstImage = diaryData.pictures?.first.flatMap({ UIImage(data: $0) }) {
                    Image(uiImage: firstImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 86, height: .infinity)
                        .clipped()
                }
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 28)
            .frame(maxHeight: .infinity, alignment: .center)

            Divider()
                .background(Color.gray20)
        }
    }
    
    // - MARK: Methods
    
    @inline(__always)
    private func trimmedContent(_ content: String, maxCharacters: Int = 71) -> String {
        if content.count > maxCharacters {
            let index = content.index(content.startIndex, offsetBy: maxCharacters)
            return String(content[..<index]) + "..."
        } else {
            return content
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
                pictures: [UIImage.checkmark.pngData()].compactMap { $0 },
                diaryDate: "2025 / 05 / 24"
            ),
            DiaryResponse(
                id: UUID(),
                title: nil,
                content: "명상의 힘은 마음을 가라앉히고 내면의 평화를 찾는 방법을 제공합니다. 정기적인 명상은 스트레스를 줄이고 집중력을 향상시키는 방법입니다.",
                pictures: [UIImage.checkmark.pngData()].compactMap { $0 },
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
