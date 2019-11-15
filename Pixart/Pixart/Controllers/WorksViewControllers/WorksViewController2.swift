//
//  WorksViewController2.swift
//  Pixart
//
//  Created by Hin Chan on 11/14/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class WorksViewController2: UIViewController {

    @IBOutlet weak var privateView: UIView!
    @IBOutlet weak var publishedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publishedView.isHidden = true;
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            privateView.isHidden = false
            publishedView.isHidden = true
            break
        case 1:
            privateView.isHidden = true
            publishedView.isHidden = false
            break
        default:
            print("Unknown segment index.")
        }
    }
    
}
