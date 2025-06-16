//
//  FriendInfoEnum.swift
//  Widi
//
//  Created by jeongminji on 6/2/25.
//

/// 친구 상세 정보를 표현하는 열거형
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
    
    var valueText: String? {
        switch self {
        case .diaryCount(let count):
            return "\(count)개"
        case .birthday(let date):
            return date
        case .hatchProgress:
            return nil
        }
    }
    
    var hatchProgressValue: Int? {
        guard case let .hatchProgress(progress) = self else { return nil }
        return progress
    }
    
    static func makeItems(from response: FriendResponse) -> [FriendInfoItem] {
        return [
            .diaryCount(response.experienceDTO.exp),
            .birthday(response.birthday ?? ""),
            .hatchProgress(response.experienceDTO.exp)
        ]
    }
}
