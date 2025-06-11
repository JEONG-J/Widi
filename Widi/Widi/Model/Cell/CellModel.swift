//
//  Cell.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import Foundation

/// 캘린더 셀의 정보 모델
struct CellModel: Identifiable {
    var id: UUID = .init()
    let day: Int?
    let date: Date?
    let isCurrentMonth: Bool
}
