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
    @IBOutlet weak var privateView_X_constraint: NSLayoutConstraint!
    @IBOutlet weak var publishedView: UIView!
    @IBOutlet weak var publishedView_X_constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showPrivateView()
            break
        case 1:
            showPublishedView()
            break
        default:
            print("Unknown segment index.")
        }
    }
    
    private func showPrivateView() {
        UIView.animate(withDuration: 0.3, animations:{
            self.publishedView_X_constraint.constant = 416
            self.privateView_X_constraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    private func showPublishedView() {
        UIView.animate(withDuration: 0.3, animations:{
            self.publishedView_X_constraint.constant = 0
            self.privateView_X_constraint.constant = -416
            self.view.layoutIfNeeded()
        })
    }
}
