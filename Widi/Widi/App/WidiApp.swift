//
//  WidiApp.swift
//  Widi
//
//  Created by Apple Coding machine on 5/28/25.
//

import SwiftUI

/// 앱 진입 지점
@main
struct WidiApp: App {
    
    @StateObject var container: DIContainer = .init()
    @StateObject var appFlowViewModel: AppFlowViewModel = .init()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            switch appFlowViewModel.appState {
            case .splash:
                WidiSplashView()
                    .environmentObject(appFlowViewModel)
            case .login:
                WidiLoginView(container: container, appFlowViewModel: appFlowViewModel)
            case .home:
                HomeView(container: container)
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
            }
        }
    }
}
