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
        .init(name: "성준이", birthDay: "04.20", experienceDTO: .init(experiencePoint: 1)),
        .init(name: "미르", birthDay: "05.20", experienceDTO: .init(experiencePoint: 2)),
        .init(name: "마이", birthDay: "06.20", experienceDTO: .init(experiencePoint: 3)),
        .init(name: "지나", birthDay: "07.20", experienceDTO: .init(experiencePoint: 4))
    ]
}
