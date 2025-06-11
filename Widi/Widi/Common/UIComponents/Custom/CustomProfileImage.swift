//
//  CustomProfileImage.swift
//  Widi
//
//  Created by jeongminji on 6/2/25.
//

import SwiftUI
import Kingfisher

/// 프로필 이미지 컴포넌트
struct CustomProfileImage: View {
    
    // MARK: - Properties
    
    private let imageURLString: String?
    private let size: CGFloat
    
    // MARK: - Init
    
    /// CustomProfileImage
    /// - Parameters:
    ///   - imageURLString: 프로필 이미지 String 값
    ///   - size: 프로필 이미지 사이즈, 옵셔널로 기본은 32
    init(imageURLString: String?, size: CGFloat = 32) {
        self.imageURLString = imageURLString
        self.size = size
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.orange10)
            
            profileImage
            
            Circle()
                .fill(Color.clear)
                .stroke(Color.orange20, style: .init(lineWidth: 1))
        }
        .frame(width: 32, height: 32)
    }
    
    /// 프로필 이미지 캐시 처리
    @ViewBuilder
    private var profileImage: some View {
        if let urlString = imageURLString,
           let url = URL(string: urlString) {
            KFImage(url)
                .downsampling(size: .init(width: 400, height: 400))
                .cacheOriginalImage()
                .placeholder({
                    ProgressView()
                        .controlSize(.small)
                }).retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .clipShape(Circle())
                .frame(width: 32, height: 32)
        } else {
            Circle()
                .fill(Color.gray10)
                .frame(width: 32, height: 32)
        }
    }
}

#Preview {
    CustomProfileImage(
        imageURLString: "https://pimg.mk.co.kr/news/cms/202403/29/20240329_01110601000001_L01.jpg",
        size: 40
    )
}
