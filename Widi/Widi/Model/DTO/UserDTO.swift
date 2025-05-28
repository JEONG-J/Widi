//
//  UserDTO.swift
//  Widi
//
//  Created by 김성현 on 2025-05-28.
//

import Foundation

/// UserTable 공통 속성
protocol UserDTO {
    var name: String { get set }
}

/// 유저 이름 조회
struct UserReponse: Codable, UserDTO {
    var name: String
}

/// 유저 생성
struct UserRequest: Codable, UserDTO {
    var identifier: String
    var name: String
}
