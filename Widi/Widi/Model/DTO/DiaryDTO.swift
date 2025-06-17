
//
//  DiaryDOT.swift
//  Widi
//
//  Created by 김성현 on 2025-05-28.
//

import Foundation
import SwiftUI
import FirebaseFirestore

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
    var userId: String
    var friendId: String
    @ServerTimestamp var createdAt: Timestamp?
}

/// 일기 조회
struct DiaryResponse: Codable, DiaryDTO, Identifiable, Hashable {
    @DocumentID var documentId: String?
    var id: UUID = .init()
    var content: String
    var createdAt: Timestamp
    var diaryDate: String
    var friendId: String
    var pictures: [String]?
    var title: String?
    var userId: String
    
    enum CodingKeys: String, CodingKey {
        case content
        case createdAt
        case diaryDate
        case friendId
        case pictures
        case title
        case userId
    }
}

struct DiaryUpdateRequest: Codable, DiaryDTO {
    var title: String?
    var content: String
    var pictures: [String]?
    var diaryDate: String
}

