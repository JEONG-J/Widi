//
//  HomeView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import SwiftUI

/// 홈 뷰
struct HomeView: View {
    
    // MARK: - Property
    @State private var hasAppeared = false
    @State private var isCharacterLoaded: Bool = false
    @State private var offset: CGFloat = .zero
    @State private var lastOffset: CGFloat = .zero
    @State var viewModel: HomeViewModel
    
    @GestureState private var dragOffset: CGFloat = .zero
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    // MARK: - Constant
    fileprivate enum HomeConstants {
        static let minScreenHeight: CGFloat = 0.89
        static let maxScreenHeight: CGFloat = 0.08
        
        static let topNaviWidth: CGFloat = 19
        static let topNaviHeight: CGFloat = 20
        static let topNaviPadding: CGFloat = 10
        static let topOffset: CGFloat = 10
    }
    
    // MARK: - Init
    
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    
    var body: some View {
        let screenHeight = getScreenSize().height
        let minOffset: CGFloat = screenHeight * HomeConstants.minScreenHeight
        let maxOffset: CGFloat = screenHeight * HomeConstants.maxScreenHeight
        let midPoint = (minOffset + maxOffset) / 2
        let shouldHideOverlay = offset < midPoint
        
        NavigationStack(path: $container.navigationRouter.destination) {
            ZStack {
                if let friends = viewModel.friendsData {
                    CharacterFloatingScene(allCharacters: $viewModel.allCharacters,
                                           isLoaded: $isCharacterLoaded,
                                           friends: friends
                    )
                }
                
                HomeDragView(viewModel: viewModel)
                    .environmentObject(container)
                    .offset(y: offset + dragOffset)
                    .gesture(dragGesture(minOffset: minOffset, maxOffset: maxOffset, midPoint: midPoint))
                    .task {
                        await initializeOffset(screenHeight: screenHeight, minOffset: minOffset)
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea()
            .background {
                Image(.homeBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            .loadingOverlay(isLoading: !isCharacterLoaded, loadingType: .homeLoading)
            .overlay(alignment: .topTrailing, content: {
                topNaviButton(shouldHideOverlay)
            })
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
            }
        }
    }
    
    /// 상단 옵션 버튼
    /// - Parameter shouldHideOverlay: 숨기기 보이기
    /// - Returns: 뷰 반환
    @ViewBuilder
    private func topNaviButton(_ shouldHideOverlay: Bool) -> some View {
        if !shouldHideOverlay {
            Button(action: {
                container.navigationRouter.push(to: .myPage)
            }, label: {
                Image(.naviSetting)
                    .resizable()
                    .frame(width: HomeConstants.topNaviWidth, height: HomeConstants.topNaviHeight)
                    .padding(HomeConstants.topNaviPadding)
                    .background {
                        Circle()
                            .fill(
                                Color.white.opacity(0.7)
                                    .shadow(.inner(color: Color.white.opacity(0.5), radius: 2, x: 2, y: 2))
                            )
                            .glass()
                    }
                
            })
            .transition(.opacity)
            .animation(.easeInOut, value: shouldHideOverlay)
            .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
            .offset(y: HomeConstants.topOffset)
        }
    }
    
    // MARK: - Offset 초기 애니메이션
    @MainActor
    private func initializeOffset(screenHeight: CGFloat, minOffset: CGFloat) async {
        if !hasAppeared {
            hasAppeared = true
            
            offset = screenHeight
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            withAnimation(.spring(response: 1.4, dampingFraction: 0.8)) {
                offset = minOffset
            }
        }
    }
    
    // MARK: - Drag Gesture
    private func dragGesture(minOffset: CGFloat, maxOffset: CGFloat, midPoint: CGFloat) -> some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                let newOffset = offset + value.translation.height
                if newOffset > minOffset {
                    state = minOffset - offset
                } else if newOffset < maxOffset {
                    state = maxOffset - offset
                } else {
                    state = value.translation.height
                }
            }
            .onEnded { value in
                let dragAmount = value.translation.height
                offset += dragAmount
                offset = offset.clamped(to: maxOffset...minOffset)
                
                let threshold: CGFloat = 5
                withAnimation(.easeInOut(duration: 0.4)) {
                    if dragAmount < -threshold {
                        offset = maxOffset
                    } else if dragAmount > threshold {
                        offset = minOffset
                    } else {
                        offset = (lastOffset < midPoint) ? maxOffset : minOffset
                    }
                }
                
                lastOffset = offset
            }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
