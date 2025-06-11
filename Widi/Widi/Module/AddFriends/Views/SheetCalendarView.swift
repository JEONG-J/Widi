//
//  SheetCalendarView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/5/25.
//

import SwiftUI

/// 커스텀 달력 뷰
struct SheetCalendarView: View {
    
    @State var viewModel: CalendarControllable
    @State var calendarViewModel: CalendarViewModel = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32, content: {
            topController
            
            CalendarComponents(viewModel: calendarViewModel)
        })
        .safeAreaPadding([.horizontal, .top], 16)
        .safeAreaPadding(.bottom, 20)
        .frame(alignment: .bottom)
        .background(Color.white)
    }
    
    /// 상단 달력 컨트롤러
    private var topController: some View {
        HStack {
            Button(action: {
                viewModel.isShowCalendar.toggle()
            }, label: {
                NavigationIcon.closeX.image
                    .padding(8)
            })
            
            Spacer()
            
            Button(action: {
                Task {
                    viewModel.dateString = ConvertDataFormat.shared.simpleDateString(from: calendarViewModel.selectedDate)
                    viewModel.isShowCalendar.toggle()
                }
            }, label: {
                if let title = NavigationIcon.complete(type: .select, isEmphasized: true).title {
                    Text(title)
                        .font(.h4)
                        .foregroundStyle(.orange30)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.whiteBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            })
        }
    }
}
