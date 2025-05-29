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
            Text("Hello, world!")
                .foregroundStyle(.tint)
        }
        .padding()
        .task {
            UIFont.familyNames.sorted().forEach { familyName in
                print("*** \(familyName) ***")
                UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                    print("\(fontName)")
                }
                print("---------------------")
            }
        }
    }
}

#Preview {
    ContentView()
}
