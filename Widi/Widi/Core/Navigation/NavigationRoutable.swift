//
//  NavigationRouter.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation

/// 화면 이동 로직을 정의하는 네비게이션 라우터용 프로토콜
protocol NavigationRoutable {
    var destination: [NavigationDestination] { get set }
    func push(to view: NavigationDestination)
    func pop()
    func popToRooteView()
}

/// 네비게이션 라우터
@Observable
class NavigationRouter: NavigationRoutable {
    var destination: [NavigationDestination] = []
    
    func push(to view: NavigationDestination) {
        destination.append(view)
    }
    
    func pop() {
        _ = destination.popLast()
    }
    
    func popToRooteView() {
        destination.removeAll()
    }
}
