//
//  FriendDTO.swift
//  Widi
//
//  Created by 김성현 on 2025-05-28.
//

import Foundation

/// 친구 공통 속성
protocol FriendDTO {
    var name: String { get set }
    var birthDay: String? { get set }
}

/// 친구 생성
struct FriendRequest: Codable, FriendDTO, Hashable {
    var name: String
    var birthDay: String?
}

/// 친구 조회
struct FriendResponse: Codable, Identifiable, Hashable {
    var id: UUID = .init() // SwiftUI List 등에서 사용
    var documentId: String // Firestore 문서 ID (삭제에 사용)
    var friendId: String   // 친구 식별자 (UID 등)
    var name: String
    var birthDay: String?
    let experienceDTO: ExperienceDTO
}
