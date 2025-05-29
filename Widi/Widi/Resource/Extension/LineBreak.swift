//
//  StringExtension.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation
import SwiftUI

extension String {
    func customLineBreak() -> String {
        return self.split(separator: "").joined(separator: "\u{200B}")
    }
}
