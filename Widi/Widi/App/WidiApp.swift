//
//  WidiApp.swift
//  Widi
//
//  Created by Apple Coding machine on 5/28/25.
//

import SwiftUI

@main
struct WidiApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(DIContainer())
        }
    }
}
