
//
//  DiaryDOT.swift
//  Widi
//
//  Created by 김성현 on 2025-05-28.
//

import Foundation
import SwiftUI

/// 일기 공통 속성
protocol DiaryDTO {
    var title: String? { get set }
    var content: String { get set }
    var pictures: [String]? { get set } // Optional 넣어놨습니다.
    var diaryDate: String { get set }
}

/// 일기 생성
struct DiaryRequest: Codable, DiaryDTO {
    var title: String?
    var content: String
    var pictures: [String]?
    var diaryDate: String
}

/// 일기 조회
struct DiaryResponse: Codable, DiaryDTO, Identifiable {
    var id: UUID = .init()
    var title: String?
    var content: String
    var pictures: [String]?
    var diaryDate: String // 일기의 실제 날짜
}
