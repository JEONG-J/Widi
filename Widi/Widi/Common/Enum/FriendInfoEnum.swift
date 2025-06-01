//
//  FriendInfoEnum.swift
//  Widi
//
//  Created by jeongminji on 6/2/25.
//

enum FriendInfoItem {
    case diaryCount(Int)
    case birthday(String)
    case hatchProgress(Int)
    
    var title: String {
        switch self {
        case .diaryCount:
            return "총 일기 개수"
        case .birthday:
            return "생일"
        case .hatchProgress:
            return "부화까지"
        }
    }
}
