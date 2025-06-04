//
//  AddFriends.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import Foundation

enum AddFriendsField: CaseIterable, AddFriendsContent {
    case name
    case birthDay
    
    var title: String {
        switch self {
        case .name:
            return "친구의 이름을 적어주세요"
        case .birthDay:
            return "친구의 생일을 알고 있나요?"
        }
    }
    
    var placeholder: String {
        switch self {
        case .name:
            return "이름"
        case .birthDay:
            return "mm / dd"
        }
    }
}
