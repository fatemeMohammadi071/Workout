//
//  UIAlertController+Extension.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import Foundation
import UIKit

extension UIAlertController {
    private static var style: UIStatusBarStyle = .default

    func setStyle(style: UIStatusBarStyle) {
        UIAlertController.style = style
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return UIAlertController.style
    }
}
