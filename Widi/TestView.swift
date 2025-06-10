//
//  TestView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/9/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .environmentObject(DIContainer())
        }
    }
}

#Preview {
    TestView()
}
