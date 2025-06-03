//
//  DIContainer.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation

class DIContainer: ObservableObject {
    @Published var navigationRouter: NavigationRouter
    
    init(
        navigationRouter: NavigationRouter = .init()
    ) {
        self.navigationRouter = navigationRouter
    }
}
