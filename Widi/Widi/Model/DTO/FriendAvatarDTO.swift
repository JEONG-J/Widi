//
//  Avatar.swift
//  Widi
//
//  Created by 김성현 on 2025-05-28.
//

import Foundation

/// 알 (부화 전)
struct EggDTO: Codable, Hashable {
    var eggColor: String
    var x: Int
    var y: Int
}

/// 캐릭터 (부화 후)
struct CharacterDTO: Codable, Hashable {
    var imageURL: String
}

/// 경험치
struct ExperienceDTO: Codable, Hashable {
    var experiencePoint: Int
    var eggInfo: EggDTO?
    var characterInfo: CharacterDTO?
}
