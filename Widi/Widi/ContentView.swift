//
//  ContentView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/28/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
            Text("Hello, world!".customLineBreak())
                .lineSpacing(1.6)
                .foregroundStyle(.tint)
                .font(.h1)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
