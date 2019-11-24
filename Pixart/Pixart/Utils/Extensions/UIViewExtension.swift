//
//  UIViewExtension.swift
//  Pixart
//
//  Created by Hin Chan on 11/23/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor = UIColor.black, opacity: Float = 0.7, x: Double = 0, y: Double = 0, radius: CGFloat = 10) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = 10
    }
}
