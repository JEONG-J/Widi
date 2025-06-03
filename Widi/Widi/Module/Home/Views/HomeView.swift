//
//  HomeView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var offset: CGFloat = .zero
    @State private var lastOffset: CGFloat = .zero
    @GestureState private var dragOffset: CGFloat = .zero
    
    var body: some View {
        ZStack {
            Color.green
            
            GeometryReader { geometry in
                let screenHeight = geometry.size.height
                let minOffset: CGFloat = screenHeight * 0.89
                let maxOffset: CGFloat = screenHeight * 0.08
                
                HomeDragView(viewModel: .init())
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
                        offset = screenHeight
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.spring(response: 1.4, dampingFraction: 0.8)) {
                                offset = minOffset
                            }
                        }
                    }
            }
        }
        .ignoresSafeArea()
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#Preview {
    HomeView()
}
