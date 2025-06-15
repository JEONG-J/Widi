//
//  Calendar.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI

/// Custom 캘린더 컴포넌트
struct CalendarComponents: View {
    // MARK: - Property
    @Bindable var viewModel: CalendarViewModel
    
    // MARK: - Components
    fileprivate enum CalendarConstants {
        static let calendarSpacing: CGFloat = 12
        static let arrowButtonSpacing: CGFloat = 12
        static let arrowButtonPadding: CGFloat = 6
        static let headerLeadingPadding: CGFloat = 24
        static let headerTrailingPadding: CGFloat = 8
        
        static let numberOfColumns: Int = 7
        static let gridSpacing: CGFloat = 8
        static let gridHorizontalPadding: CGFloat = 16

        static let weekdayTextVerticalPadding: CGFloat = 9
        static let weekdayTextHorizontalPadding: CGFloat = 13
        
        static let calendarHeaderDateFormat = "yyyy년 MM월"
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: CalendarConstants.calendarSpacing, content: {
            headerController
            calendarGrid
        })
        .background(Color.whiteBlack)
    }
    
    /// 달력 상단 컨트롤러
    private var headerController: some View {
        HStack(content: {
            Text(viewModel.currentMonth, formatter: calendarHeaderDateFormatter)
                .font(.h2)
                .foregroundStyle(Color.gray60)
            
            Spacer()
            
            HStack(spacing: CalendarConstants.calendarSpacing, content: {
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
            .padding(CalendarConstants.arrowButtonPadding)
        })
        .padding(.leading, CalendarConstants.headerLeadingPadding)
        .padding(.trailing, CalendarConstants.headerTrailingPadding)
    }
    
    /// 달력 하단 날짜 그리드
    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: CalendarConstants.gridSpacing), count: CalendarConstants.numberOfColumns), spacing: CalendarConstants.gridSpacing, content: {
            ForEach(localizedWeekdaySymbols.indices, id: \.self) { index in
                Text(localizedWeekdaySymbols[index])
                    .foregroundStyle(Color.gray30)
                    .font(.btn)
                    .padding(.vertical, CalendarConstants.weekdayTextVerticalPadding)
                    .padding(.horizontal, CalendarConstants.weekdayTextHorizontalPadding)
            }
            
            ForEach(viewModel.daysForCurrentGrid(), id: \.id) { calendarDay in
                let isSelectedDate = calendarDay.date.map {
                    viewModel.calendar.isDate($0, inSameDayAs: viewModel.selectedDate)
                } ?? false

                Cell(calendarDay: calendarDay, isSelected: isSelectedDate, viewModel: viewModel)
            }
        })
        .frame(alignment: .top)
        .padding(.horizontal, CalendarConstants.gridHorizontalPadding)
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
        formatter.dateFormat = CalendarConstants.calendarHeaderDateFormat
        return formatter
    }()
}

#Preview {
    VStack {
        CalendarComponents(viewModel: .init())
            .safeAreaPadding(.horizontal, 16)
    }
}
