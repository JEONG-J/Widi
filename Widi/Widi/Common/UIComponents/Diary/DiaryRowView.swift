//
//  DiaryRowView.swift
//  Widi
//
//  Created by jeongminji on 6/4/25.
//

import SwiftUI

/// DiaryPreviewCard에 Divider  긋고, DeleteButtonView랑 중첩한 일기 카드
struct DiaryRowView: View {
    
    // MARK: - Properties
    
    let diary: DiaryResponse
    
    @Binding var offset: CGFloat
    @Binding var allOffsets: [UUID: CGFloat]
    let deleteAction: () -> Void
    
    private let deleteButtonWidth: CGFloat = 68
    private let dragThreshold: CGFloat = 15
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .trailing) {
            DiaryPreviewCard(diaryData: diary)
                .offset(x: offset)
                .simultaneousGesture(dragGesture)
            
            if abs(offset) > dragThreshold {
                deleteButtonView {
                    deleteAction()
                }
            }
        }
        .contentShape(Rectangle())
        .animation(.easeInOut, value: offset)
    }
    
    // MARK: - Subviews
    
    /// deleteButtonView
    /// - Parameter action: 클릭 시 액션
    /// - Returns: 삭제 버튼 뷰 리턴
    @ViewBuilder
    private func deleteButtonView(action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Image(.delete)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(.white)
                .frame(width: deleteButtonWidth)
                .frame(maxHeight: .infinity)
        }
        .alignmentGuide(.leading) { _ in 0 }
        .background(Color.red30)
        .transition(.move(edge: .trailing).animation(.easeInOut.speed(1)))
    }
    
    // MARK: - Methods
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { handleDragChanged($0) }
            .onEnded { handleDragEnded($0) }
    }
    
    /// 드래그 중 액션, 드래그 범위 제한
    /// - Parameter value: 드래그 값
    private func handleDragChanged(_ value: DragGesture.Value) {
        if abs(value.translation.width) > abs(value.translation.height) {
            if value.translation.width < 0 {
                closeOtherCards(except: diary.id)
                offset = max(value.translation.width, -deleteButtonWidth)
            } else {
                offset = 0
            }
        }
    }
    
    /// 드래그 멈춘 후 액션, 드래그 값 기반으로 삭제 버튼 열릴지, 닫힐 지 결정
    /// - Parameter value: 드래그 값
    private func handleDragEnded(_ value: DragGesture.Value) {
        if abs(value.translation.width) > abs(value.translation.height) {
            withAnimation {
                if value.translation.width < -deleteButtonWidth / 2 {
                    offset = -deleteButtonWidth
                } else {
                    offset = 0
                }
            }
        }
    }
    
    /// 일기 카드가 열릴때, 열려있는 다른 카드 닫히게 함
    /// - Parameter id: 현재 드래그 중인 일기 카드 id
    private func closeOtherCards(except id: UUID) {
        for key in allOffsets.keys where key != id {
            allOffsets[key] = 0
        }
    }
}
