//
//  CustomizeTextfield.swift
//  Pixart
//
//  Created by Hin Chan on 11/21/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftImage(image: String, cornerRadius: CGFloat = 0) {
        addLeftImage(image: UIImage(named: image), radius: cornerRadius)
    }
    
    func setLeftImage(systemImage: String, cornerRadius: CGFloat = 0) {
        addLeftImage(image: UIImage(systemName: systemImage), radius: cornerRadius)
    }
    
    func addLeftPadding(width: Int) {
        let containerView: UIView = UIView(frame:
        CGRect(x: 0, y: 0, width: width, height: 40))
        self.leftView = containerView
        self.leftViewMode = .always
    }
    
    private func addLeftImage(image: UIImage?, radius: CGFloat) {
        let imageView = UIImageView(frame:
                       CGRect(x: 10, y: 10, width: 20, height: 20))
        let imageContainerView: UIView = UIView(frame:
                       CGRect(x: 0, y: 0, width: 40, height: 40))
        let containerView: UIView = UIView(frame:
        CGRect(x: 20, y: 0, width: 50, height: 40))
        imageView.image = image
        imageView.tintColor = UIColor.gray
        imageView.contentMode = .scaleAspectFit
        imageContainerView.addSubview(imageView)
        imageContainerView.backgroundColor = UIColor.white
        imageContainerView.layer.cornerRadius = radius
        containerView.addSubview(imageContainerView)
        self.leftView = containerView
        self.leftViewMode = .always
    }
}
