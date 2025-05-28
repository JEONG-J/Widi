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
    var birthDay: String { get set }
}

/// 친구 생성
struct FriendRequest: Codable, FriendDTO {
    var name: String
    var birthDay: String
}

/// 친구 조회
struct FriendResponse: Codable, FriendDTO, Identifiable {
    var id: UUID = .init()
    var name: String
    var birthDay: String
    var experiencePoint: Int
    var eggInfo: EggDTO?
    var characterINfo: CharacterDTO?
}

