//
//  DiaryImage.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import Foundation
import SwiftUI

enum DiaryImage: Identifiable, Equatable {
    case local(Image)
    case server(String)
    
    var id: String {
        switch self {
        case .local:
            return UUID().uuidString
        case .server(let urlString):
            return urlString
        }
    }
}
