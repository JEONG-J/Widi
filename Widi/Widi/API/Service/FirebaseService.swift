//
//  FirebaseService.swift
//  Widi
//
//  Created by Apple Coding machine on 6/9/25.
//

import Foundation

/// Firebase 인증 관련 기능 클래스
@Observable
final class FirebaseService {
    
    let auth: FirebaseAuthManager
    
    init() {
        self.auth = FirebaseAuthManager()
    }
}
