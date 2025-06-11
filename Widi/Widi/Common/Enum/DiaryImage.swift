//
//  DiaryImage.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import Foundation
import SwiftUI

/// 서버 또는 로컬 이미지 정보를 나타내는 일기 이미지 열거형
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
