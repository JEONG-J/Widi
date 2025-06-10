//
//  DetailFirendUpdateViewModel.swift
//  Widi
//
//  Created by Miru on 2025/6/5.
//

import Foundation

@Observable
class DetailFriendUpdateViewModel {
    
    // MARK: - Property
    var nameText: String = ""
    var birthdayText: String = ""
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func sendUpadte() async {
        print("complete")
    }
}
