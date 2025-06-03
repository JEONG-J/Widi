//
//  HomeViewModels.swift
//  Widi
//
//  Created by Apple Coding machine on 5/30/25.
//

import Foundation

@Observable
class HomeViewModel {
    var friendsData: [FriendResponse]? = [
        .init(name: "11", birthDay: "11", experienceDTO: .init(experiencePoint: 11)),
        .init(name: "12", birthDay: "121", experienceDTO: .init(experiencePoint: 11)),
        .init(name: "13", birthDay: "112", experienceDTO: .init(experiencePoint: 11)),
        .init(name: "14", birthDay: "113", experienceDTO: .init(experiencePoint: 11)),
        .init(name: "15", birthDay: "1114", experienceDTO: .init(experiencePoint: 11)),
        .init(name: "16", birthDay: "1115", experienceDTO: .init(experiencePoint: 11)),
        .init(name: "17", birthDay: "11123", experienceDTO: .init(experiencePoint: 11)),
        .init(name: "18", birthDay: "11123", experienceDTO: .init(experiencePoint: 11)),
        .init(name: "19", birthDay: "11231", experienceDTO: .init(experiencePoint: 11)),
    ]
}
