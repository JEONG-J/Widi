//
//  ResizeImage.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import UIKit

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
