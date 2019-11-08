//
//  FeedsViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu

class FeedsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.layer.borderWidth = 5
        image.layer.borderColor = UIColor.gray.cgColor
        // Do any additional setup after loading the view.
    }
}
