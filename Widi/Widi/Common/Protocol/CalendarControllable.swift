//
//  CalendarControllable.swift
//  Widi
//
//  Created by Apple Coding machine on 6/11/25.
//

import Foundation

protocol CalendarControllable: AnyObject {
    var isShowCalendar: Bool { get set }
    var dateString: String { get set }
}
