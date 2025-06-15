//
//  SheetCalendarView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/5/25.
//

import SwiftUI

/// 커스텀 달력 뷰
struct SheetCalendarView: View {
    // MARK: - Property
    @State var viewModel: CalendarControllable
    @State var calendarViewModel: CalendarViewModel = .init()
    
    // MARK: - Constants
    fileprivate enum SheetCalendarViewConstants {
        static let contentsSpacing: CGFloat = 32
        static let topPadding: CGFloat = 24
        
        static let topControllerVerticalPadding: CGFloat = 10
        static let topControllerHorizontalPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 20
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: SheetCalendarViewConstants.contentsSpacing, content: {
            topController
            
            CalendarComponents(viewModel: calendarViewModel)
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultHorizontalPadding)
        .safeAreaPadding(.top, SheetCalendarViewConstants.topPadding)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.white)
    }
    
    /// 상단 달력 컨트롤러
    private var topController: some View {
        HStack {
            Button(action: {
                viewModel.isShowCalendar.toggle()
            }, label: {
                NavigationIcon.closeX.image
                    .padding(NavigationIcon.closeX.paddingValue)
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
                        .padding(.vertical, SheetCalendarViewConstants.topControllerVerticalPadding)
                        .padding(.horizontal, SheetCalendarViewConstants.topControllerHorizontalPadding)
                        .background(Color.whiteBlack)
                        .clipShape(RoundedRectangle(cornerRadius: SheetCalendarViewConstants.cornerRadius))
                }
            })
        }
    }
}
