//
//  DiaryImage.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import Foundation
import SwiftUI

enum DiaryImage: Identifiable, Equatable, Hashable {
    case local(Image, id: UUID = UUID())
    case server(String)
    
    var id: String {
        switch self {
        case .local(_, let id):
            return id.uuidString
        case .server(let urlString):
            return urlString
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: DiaryImage, rhs: DiaryImage) -> Bool {
        lhs.id == rhs.id
    }
}
