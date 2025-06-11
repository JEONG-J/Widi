//
//  Avatar.swift
//  Widi
//
//  Created by 김성현 on 2025-05-28.
//

import Foundation

/// 캐릭터
struct CharacterDTO: Codable, Hashable {
    var imageURL: String
    var x: Int
    var y: Int
}

/// 경험치
struct ExperienceDTO: Codable, Hashable {
    var experiencePoint: Int
    var characterInfo: CharacterDTO
}
