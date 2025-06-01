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
    
    var numberOfPages: Int
    var currentPage: Int
    
    // MARK: - Init
    
    /// PicturePageIndicator
    /// - Parameters:
    ///   - numberOfPages: 총 사진 페이지 수
    ///   - currentPage: 현재 사진 페이지의 인덱스
    init(numberOfPages: Int, currentPage: Int) {
        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack (spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .foregroundColor(index == currentPage ? .orange30: .gray20)
            }
        }
    }
}

#Preview {
    PicturePageIndicator(numberOfPages: 5, currentPage: 3)
        .frame(height: 10)
}
