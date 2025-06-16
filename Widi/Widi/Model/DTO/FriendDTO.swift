//
//  FriendDTO.swift
//  Widi
//
//  Created by 김성현 on 2025-05-28.
//

import Foundation
import FirebaseFirestore

struct FriendDTO: Codable {
    let userId: String
    let friendId: String
    let name: String
    let birthday: String?
    @ServerTimestamp var createdAt: Timestamp? = nil
}

/// 친구 생성
struct FriendRequest: Codable, Hashable {
    let name: String
    let birthday: String?
}

/// 친구 조회
struct FriendResponse: Codable, Identifiable, Hashable {
    @DocumentID var documentId: String?
    var friendId: String
    var name: String
    var birthday: String?
    var experienceDTO: ExperienceDTO
    var id: String { documentId ?? UUID().uuidString }
    
    enum CodingKeys: String, CodingKey {
        case friendId
        case name
        case birthday
        case experienceDTO
    }
    
}

struct RawFriend: Codable {
    var friendId: String
    var name: String
    var birthday: String?
}
