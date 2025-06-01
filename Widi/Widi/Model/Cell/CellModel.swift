//
//  Cell.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import Foundation

struct CellModel: Identifiable {
    var id: UUID = .init()
    let day: Int?
    let date: Date?
    let isCurrentMonth: Bool
}
