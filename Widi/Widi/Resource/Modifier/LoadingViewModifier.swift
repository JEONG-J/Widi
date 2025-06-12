//
//  LoadingViewModifier.swift
//  Widi
//
//  Created by Apple Coding machine on 6/11/25.
//

import Foundation
import SwiftUI

struct LoadingModifier: ViewModifier {
    
    enum LoadingTextType: String {
        case diary = "친구와 일기를 생성하고 있어요! 잠시만 기다려주세요 💌"
        case editDiary = "일기를 수정하고 있어요! 잠시만 기다려주세요 📝"
        case delete = "친구를 삭제중입니다! 잠시만 기다려주세요 🗑️"
        case diaryDelete = "일기를 삭제중입니다.! 잠시만 기다려주세요 🗑️"
    }
    
    let isLoading: Bool
    let loadingType: LoadingTextType
    
    func body(content: Content) -> some View {
        content
            .overlay(content: {
                
                if isLoading {
                    ZStack(content: {
                        Color.black.opacity(0.75)
                        
                        ProgressView(label: {
                            Text(loadingType.rawValue)
                                .lineLimit(2)
                                .lineSpacing(2.5)
                                .multilineTextAlignment(.center)
                                .font(.b1)
                                .foregroundStyle(Color.whiteBlack)
                        })
                        
                        .tint(Color.orange30)
                        .controlSize(.large)
                    })
                    .ignoresSafeArea()
                    .zIndex(2)
                }
            })
    }
}

extension View {
    func loadingOverlay(isLoading: Bool, loadingType: LoadingModifier.LoadingTextType) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading, loadingType: loadingType))
    }
}
