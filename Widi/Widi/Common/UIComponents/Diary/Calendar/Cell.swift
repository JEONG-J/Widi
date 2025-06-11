//
//  Cell.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI

/// 캘린더 개별 날짜 셀 컴포넌트
struct Cell: View {
    
    var calendarDay: CellModel
    var isSelected: Bool
    @Bindable var viewModel: CalendarViewModel
    
    var body: some View {
        ZStack {
            if let day = calendarDay.day {
                if isSelected {
                    Circle()
                        .fill(Color.orange30)
                        .frame(width: 40, height: 40)
                        .transition(.scale.combined(with: .opacity))
                }
                
                Text("\(day)")
                    .font(.h3)
                    .foregroundStyle(textColor)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDate)
            }
        }
        .frame(width: 40, height: 40)
        .onTapGesture {
            guard let date = calendarDay.date else { return }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                viewModel.changeSelectedDate(date)
            }
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return Color.whiteBlack
        } else {
            return Color.gray60
        }
    }
}
