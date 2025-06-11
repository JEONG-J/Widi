//
//  CalendarViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import Foundation
import SwiftUI

/// Custom 캘린더 뷰모델
@Observable
class CalendarViewModel {
    var currentMonth: Date
    var selectedDate: Date
    var calendar: Calendar
    
    var currentMonthYear: Int {
        Calendar.current.component(.year, from: currentMonth)
    }
    
    init(
        currentMonth: Date = .init(),
        selectdDate: Date = .init(),
        calendar: Calendar = .current
    ) {
        self.currentMonth = currentMonth
        self.selectedDate = selectdDate
        self.calendar = calendar
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func daysForCurrentGrid() -> [CellModel] {
        let calendar = Calendar.current
        /*
         현재 월의 정보를 계산합니다.
         이 달의 첫 날짜를 기준으로 시작 요일, 일 수 계산을 합니다.
        */
        let firstDay = firstDayOfMonth()
        let firstWeekDay = calendar.component(.weekday, from: firstDay)
        let daysInMonth = numberOfDays(in: currentMonth)
        
        var days: [CellModel] = []
        
        /*
         이번 달이 무슨 요일에 시작하는지에 따라, 앞에 몇 개의 셀을 이전 달의 날짜로 채울지 계산합니다.
         */
        let leadingDays = (firstWeekDay - calendar.firstWeekday + 7) % 7
        
        /*
         달력은 보통 7일 단위 그리드로 구성됩니다.
         어떤 달이 수요일에 시작한다면 앞의 일/월/화는 빈공간이 아닌 이전 달의 날짜로 미리보기로 보이도록 할 수 있죠!
         그래서 이 코드는 그 앞 부분 회색을 생성하는 부분입니다.
         실제 날짜를 추가하기 전, 외부 API로 미리 공휴일 정보를 가져오고 날짜를 구성하면서 공휴일 데이터를 넣어 구성합니다.
        */
        if leadingDays > 0, let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            let daysInPreviousMonth = numberOfDays(in: previousMonth)
            for i in 0..<leadingDays {
                let day = daysInPreviousMonth - leadingDays + 1 + i
                if let _ = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    days.append(.init(day: nil, date: nil, isCurrentMonth: false))
                }
            }
        }
        
        /*
         이번 달 날짜를 추가합니다.
         현재 달에 속한 실제 날짜를 추가해요!
         실제 날짜를 추가하기 전, 외부 API로 미리 공휴일 정보를 가져오고 날짜를 구성하면서 공휴일 데이터를 넣어 구성합니다.
         */
        for day in 1...daysInMonth {
            var components = calendar.dateComponents([.year, .month], from: currentMonth)
            components.day = day
            components.hour = 0
            components.minute = 0
            components.second = 0
            
            if let date = calendar.date(from: components) {
                days.append(.init(day: day, date: date, isCurrentMonth: true))
            }
        }
        
        /*
         전체 날짜 수가 7의 배수가 아니라면, 마지막 주를 채우기 위한 다음 달 날짜를 추가합니다.
         실제 날짜를 추가하기 전, 외부 API로 미리 공휴일 정보를 가져오고 날짜를 구성하면서 공휴일 데이터를 넣어 구성합니다.
         */
        let remaining = (7 - days.count % 7) % 7
        if remaining > 0,
           let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            
            let daysInNextMonth = numberOfDays(in: nextMonth)
            
            for day in 1...remaining {
                let validDay = min(day, daysInNextMonth)
                if let _ = calendar.date(bySetting: .day, value: validDay, of: nextMonth) {
                    days.append(.init(day: nil, date: nil, isCurrentMonth: false))
                }
            }
        }
        
        return days
        
    }
    
    func numberOfDays(in date: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    private func firstWeekdayOfMonth(in date: Date) ->  Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDay = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: firstDay)
    }
    
    func firstDayOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func changeSelectedDate(_ date: Date) {
        if calendar.isDate(selectedDate, inSameDayAs: date) {
            return
        } else {
            selectedDate = date
        }
    }
}
