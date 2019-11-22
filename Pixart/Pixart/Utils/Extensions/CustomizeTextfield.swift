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
    func setLeftImage(image: String) {
        let imageView = UIImageView(frame: CGRect(x :0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: image)
        self.leftView = imageView
        self.leftViewMode = .always
    }
    
    func setLeftImage(systemImage: String) {
        let imageView = UIImageView(frame: CGRect(x :0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(systemName: systemImage)
        imageView.tintColor = UIColor.gray
        self.leftView = imageView
        self.leftViewMode = .always
    }
}
