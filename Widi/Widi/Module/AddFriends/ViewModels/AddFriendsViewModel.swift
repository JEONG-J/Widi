//
//  AddFriendsViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import Foundation
import PhotosUI
import SwiftUI

@Observable
class AddFriendsViewModel {
    
    // MARK: - StateProperty
    var currentPage: Int = 1
    
    // MARK: - Friends
    var friendsName: String = ""
    var friendsBirthDay: String = ""
}
