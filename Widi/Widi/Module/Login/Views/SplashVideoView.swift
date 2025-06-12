//
//  SplashVideoView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/12/25.
//

import SwiftUI
import AVKit

struct SplashVideoView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer)

        player.play()

        // 터치 비활성화 (선택 사항)
        view.isUserInteractionEnabled = false

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // 업데이트 없음
    }
}
