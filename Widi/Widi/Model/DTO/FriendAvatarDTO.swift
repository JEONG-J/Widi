//
//  Avatar.swift
//  Widi
//
//  Created by 김성현 on 2025-05-28.
//

import Foundation

/// 알 (부화 전)
struct EggDTO: Codable {
    var eggColor: String
    var x: Int
    var y: Int
}

/// 캐릭터 (부화 후)
struct CharacterDTO: Codable {
    var imageURL: String
}

struct ExperienceDTO: Codable {
    var experiencePoint: Int
    var eggInfo: EggDTO?
    var characterInfo: CharacterDTO?
}
