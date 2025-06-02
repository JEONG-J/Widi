//
//  PicturePageController.swift
//  Widi
//
//  Created by 김성현 on 2025-06-02.
//

import SwiftUI

/// 사진 페이지 인디케이터 컴포넌트 (일기 작성 - 사진 클릭시)
struct PicturePageIndicator: View {
    
    // MARK: - Properties
    
    let numberOfPages: Int
    @Binding var currentPage: Int // 바뀌는 값으로 부모에게 값을 계속 주입받아야 하므로 Binding을 사용했다.
    
    // MARK: - Init
    
    /// PicturePageIndicator
    /// - Parameters:
    ///   - numberOfPages: 총 사진 페이지 수
    ///   - currentPage: 현재 사진 페이지의 인덱스
    init(numberOfPages: Int, currentPage: Binding<Int>) {
        self.numberOfPages = numberOfPages
        self._currentPage = currentPage
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack (spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .foregroundStyle(index == currentPage ? .orange30: .gray20)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var index = 1
    PicturePageIndicator(numberOfPages: 5, currentPage: $index)
        .frame(height: 10)
}

