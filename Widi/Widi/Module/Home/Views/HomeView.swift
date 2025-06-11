//
//  HomeView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import SwiftUI

/// 홈 뷰
struct HomeView: View {
    
    @State private var hasAppeared = false
    @State private var offset: CGFloat = .zero
    @State private var lastOffset: CGFloat = .zero
    @GestureState private var dragOffset: CGFloat = .zero
    @EnvironmentObject var container: DIContainer
    @Bindable var viewModel: HomeViewModel
    
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    var body: some View {
        
        let screenHeight = getScreenSize().height
        let minOffset: CGFloat = screenHeight * 0.89
        let maxOffset: CGFloat = screenHeight * 0.08
        let midPoint = (minOffset + maxOffset) / 2
        let shouldHideOverlay = offset < midPoint
        
        NavigationStack(path: $container.navigationRouter.destination) {
            ZStack {
                if let friends = viewModel.friendsData {
                    CharacterFloatingScene(friends: friends)
                }
                
                HomeDragView(viewModel: viewModel)
                    .environmentObject(container)
                    .offset(y: offset + dragOffset)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset, body: { value, state, _ in
                                let newOffset = offset + value.translation.height
                                if newOffset > minOffset {
                                    state = minOffset - offset
                                } else if newOffset < maxOffset {
                                    state = maxOffset - offset
                                } else {
                                    state = value.translation.height
                                }
                            })
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
                                        offset = (lastOffset < (maxOffset + minOffset) / 2) ? maxOffset : minOffset
                                    }
                                }
                                
                                lastOffset = offset
                            }
                    )
                    .task {
                        if !hasAppeared {
                            hasAppeared = true
                            offset = screenHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.spring(response: 1.4, dampingFraction: 0.8)) {
                                    offset = minOffset
                                }
                            }
                        }
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
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(container)
            }
            .overlay(alignment: .topTrailing, content: {
                if !shouldHideOverlay {
                        Button(action: {
                            container.navigationRouter.push(to: .myPage)
                        }, label: {
                            Image(.naviSetting)
                                .resizable()
                                .frame(width: 19, height: 20)
                                .padding(10)
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
                        .safeAreaPadding(.horizontal, 16)
                        .offset(y: 59)
                }
            })
        }
    }
}

#Preview {
    HomeView(container: DIContainer())
        .environmentObject(DIContainer())
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
