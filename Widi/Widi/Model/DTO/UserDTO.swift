//
//  UserDTO.swift
//  Widi
//
//  Created by 김성현 on 2025-05-28.
//

import Foundation
import FirebaseFirestore

/// UserTable 공통 속성
protocol UserDTO {
    var name: String { get set }
    var toogle: Bool { get set }
}

/// 유저 이름 조회
struct UserResponse: Codable, UserDTO {
    var toogle: Bool
    var name: String
}

/// 유저 생성
struct UserRequest: Codable, UserDTO {
    var name: String
    var toogle: Bool
    @ServerTimestamp var createdAt: Timestamp? = nil
}
