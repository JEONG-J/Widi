//
//  NavigationRoutingView.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import SwiftUI

struct NavigationRoutingView: View {
    
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .test:
            Text("11")
        }
    }
}
