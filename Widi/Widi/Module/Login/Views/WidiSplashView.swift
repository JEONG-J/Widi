//
//  WidiSplashView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/11/25.
//

import SwiftUI

struct WidiSplashView: View {
    
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    var body: some View {
        Text("hello")
            .task {
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                await appFlowViewModel.configureInitialAppState()
            }
    }
}

#Preview {
    WidiSplashView()
        .environmentObject(AppFlowViewModel())
}
