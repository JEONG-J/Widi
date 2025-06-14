//
//  NavigationRouter.swift
//  Widi
//
//  Created by Apple Coding machine on 6/14/25.
//

import Foundation
import UIKit

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
