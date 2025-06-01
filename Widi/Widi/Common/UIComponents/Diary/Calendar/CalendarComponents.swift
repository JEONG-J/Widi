//
//  Calendar.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI

struct CalendarComponents: View {
    
    @Bindable var viewModel: CalendarViewModel
    
    init() {
        self.viewModel = .init()
    }
    
    var body: some View {
        VStack(spacing: 12, content: {
            headerController
            calendarGrid
        })
        .background(.clear)
    }
    
    private var headerController: some View {
        HStack(content: {
            Text(viewModel.currentMonth, formatter: calendarHeaderDateFormatter)
                .font(.h2)
                .foregroundStyle(Color.gray60)
            
            Spacer()
            
            HStack(spacing: 12, content: {
                Button(action: {
                    viewModel.changeMonth(by: -1)
                }, label: {
                    Image(.left)
                })
                
                Button(action: {
                    viewModel.changeMonth(by: 1)
                }, label: {
                    Image(.right)
                })
            })
        })
        .padding(.leading, 26)
        .padding(.trailing, 20)
    }
    
    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8, content: {
            ForEach(localizedWeekdaySymbols.indices, id: \.self) { index in
                Text(localizedWeekdaySymbols[index])
                    .foregroundStyle(Color.gray30)
                    .font(.btn)
                    .padding(.vertical, 9)
                    .padding(.horizontal, 13)
            }
            
            ForEach(viewModel.daysForCurrentGrid(), id: \.id) { calendarDay in
                let isSelectedDate = calendarDay.date.map {
                    viewModel.calendar.isDate($0, inSameDayAs: viewModel.selectedDate)
                } ?? false

                Cell(calendarDay: calendarDay, isSelected: isSelectedDate, viewModel: viewModel)
            }
        })
        .frame(height: 352, alignment: .top)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    /// 요일 이름 한글로 가져오기
    let localizedWeekdaySymbols: [String] = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.shortWeekdaySymbols ?? []
    }()
    
    /// 헤더 날짜 표시 포맷터
    let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
}

#Preview {
    VStack {
        CalendarComponents()
            .safeAreaPadding(.horizontal, 16)
    }
}
