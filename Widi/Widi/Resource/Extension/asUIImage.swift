//
//  asUIImage.swift
//  Widi
//
//  Created by Apple Coding machine on 6/11/25.
//

import Foundation
import SwiftUI

extension Image {
    func asUIImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.main.async {
            let controller = UIHostingController(rootView: self)
            let view = controller.view

            let size = CGSize(width: 300, height: 300)
            view?.bounds = CGRect(origin: .zero, size: size)
            view?.backgroundColor = .clear

            let renderer = UIGraphicsImageRenderer(size: size)
            let image = renderer.image { _ in
                view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
            }

            completion(image)
        }
    }
}
