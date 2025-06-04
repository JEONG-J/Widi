//
//  AddFriendsViewModel.swift
//  Widi
//
//  Created by Apple Coding machine on 6/4/25.
//

import Foundation

@Observable
class AddFriendsViewModel {
    var currentPage: Int = 1
    
    var friendsName: String = ""
    var friendsBirthDay: String = ""
    
    var diaryTitle: String = ""
    var diaryContents: String = "" {
        didSet {
            diaryIsEmphasized = !diaryContents.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    var diaryIsEmphasized: Bool = false
    
    
    public func addFriendsAndDiary() {
        print("완료")
    }
}
