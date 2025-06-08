//
//  DiaryContainerView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/8/25.
//

import SwiftUI

struct DiaryContainerView<Header: View, Content: View, ImageScroll: View, VM: DiaryViewModelProtocol> : View {
    @ObservedObject var viewModel: VM
    
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
    }
}
