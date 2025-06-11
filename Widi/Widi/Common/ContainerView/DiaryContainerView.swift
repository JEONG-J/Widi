//
//  DiaryContainerView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import SwiftUI

/// 일기 작성 화면 내용 구성 컨테이너 뷰
struct DiaryContainerView<Header: View, Content: View, ImageScroll: View> : View {
    
    @ViewBuilder var header: () -> Header
    @ViewBuilder var imageScroll: () -> ImageScroll
    @ViewBuilder var content: () -> Content
    
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack(spacing: 8, content: {
            header()
            
            imageScroll()
            
            content()
        })
        .background(Color.background)
    }
}
