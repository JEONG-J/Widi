//
//  ContentView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/28/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var text: String = ""
    var body: some View {
        VStack {
            TextField(text: $text, label: {
                Text("!1")
            })
            .keyboardType(.numberPad)
            .onChange(of: text, { old, new in
                text = ConvertDataFormat.shared.formatBirthdayInput(new)
                
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
