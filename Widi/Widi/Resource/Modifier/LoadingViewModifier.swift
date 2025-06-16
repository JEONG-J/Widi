//
//  LoadingViewModifier.swift
//  Widi
//
//  Created by Apple Coding machine on 6/11/25.
//

import Foundation
import SwiftUI

struct LoadingModifier: ViewModifier {
    
    // MARK: - Property
    let isLoading: Bool
    let loadingType: LoadingTextType
    
    enum LoadingTextType: String {
        case createFriendDiary = "친구와의 일기를 생성 중이에요. 잠시만 기다려주세요 💌"
        case createDiary = "일기를 생성 중이에요. 잠시만 기다려주세요 💌"
        case editDiary = "일기를 수정 중이에요. 잠시만 기다려주세요 📝"
        case delete = "친구를 삭제하는 중이에요. 잠시만 기다려주세요 🗑️"
        case diaryDelete = "일기를 삭제하는 중이에요. 잠시만 기다려주세요 🗑️"
        case diaryFriendInfo = "친구 및 일기 정보를 불러오는 중이에요 🤔"
        case homeLoading = "캐릭터 친구들을 불러온느 중이에요! 👻"
    }
    
    fileprivate enum LoadingViewModifierConstants {
        static let lineLimit: Int = 2
        static let lineSpacing: CGFloat = 2.5
        static let zIndex: Double = 2
    }
    
    // MARK: - Init
    init(isLoading: Bool, loadingType: LoadingTextType) {
        self.isLoading = isLoading
        self.loadingType = loadingType
    }
    
    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .overlay(content: {
                
                if isLoading {
                    ZStack(content: {
                        Color.black.opacity(0.75)
                        
                        ProgressView(label: {
                            Text(loadingType.rawValue)
                                .lineLimit(LoadingViewModifierConstants.lineLimit)
                                .lineSpacing(LoadingViewModifierConstants.lineSpacing)
                                .multilineTextAlignment(.center)
                                .font(.b1)
                                .foregroundStyle(Color.whiteBlack)
                        })
                        
                        .tint(Color.orange30)
                        .controlSize(.large)
                    })
                    .ignoresSafeArea()
                    .zIndex(LoadingViewModifierConstants.zIndex)
                }
            })
    }
}

extension View {
    func loadingOverlay(isLoading: Bool, loadingType: LoadingModifier.LoadingTextType) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading, loadingType: loadingType))
    }
}
