//
//  SheetCalendarView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/5/25.
//

import SwiftUI

struct SheetCalendarView: View {
    
    @Bindable var viewModel: CreateDiaryViewModel
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
            
            CustomNavigationIcon(navigationIcon: .complete(type: .select, isEmphasized: true), action: {
                Task {
                    viewModel.simpleDateString(from: calendarViewModel.selectedDate)
                    viewModel.isShowCalendar.toggle()
                }
            })
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SheetCalendarView(viewModel: .init(friendRequest: .init(name: "11", birthDay: "11")))
}
