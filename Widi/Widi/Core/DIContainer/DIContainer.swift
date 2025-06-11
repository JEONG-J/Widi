//
//  DIContainer.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation

/// 앱 전역에서 사용할 네비게이션 및 Firebase 서비스를 관리하는 의존성 주입 컨테이너
class DIContainer: ObservableObject {
    @Published var navigationRouter: NavigationRouter
    @Published var firebaseService: FirebaseService
    
    init(
        navigationRouter: NavigationRouter = .init(),
        firebaseService: FirebaseService = .init()
    ) {
        self.navigationRouter = navigationRouter
        self.firebaseService = firebaseService
    }
}
