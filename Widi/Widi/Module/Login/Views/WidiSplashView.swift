//
//  WidiSplashView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/11/25.
//

import SwiftUI
import AVFoundation

struct WidiSplashView: View {
    
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    private let player: AVPlayer = {
        guard let path = Bundle.main.path(forResource: "splash", ofType: "mp4") else {
            fatalError("splash_4.mp4 not found")
        }
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        player.isMuted = true // 필요 시 음소거
        return player
    }()

    var body: some View {
        SplashVideoView(player: player)
            .ignoresSafeArea()
            .task {
                try? await Task.sleep(nanoseconds: 2_500_000_000)
                await appFlowViewModel.configureInitialAppState()
            }
    }
}
