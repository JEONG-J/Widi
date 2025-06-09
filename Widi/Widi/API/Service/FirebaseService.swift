//
//  FirebaseService.swift
//  Widi
//
//  Created by Apple Coding machine on 6/9/25.
//

import Foundation

@Observable
final class FirebaseService {
    
    let auth: FirebaseAuthManager
    
    init() {
        self.auth = FirebaseAuthManager()
    }
}
