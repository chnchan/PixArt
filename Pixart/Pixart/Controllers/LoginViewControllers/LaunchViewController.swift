//
//  LaunchViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/23/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var card_view: UIView!
    @IBOutlet weak var card_view_Y_constraint: NSLayoutConstraint!
    @IBOutlet weak var card_view_height: NSLayoutConstraint!
    @IBOutlet weak var card_view_width: NSLayoutConstraint!
    @IBOutlet weak var logo_view: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logo_Y_constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card_view.addShadow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, animations: {
            self.logo_Y_constraint.constant = -220
            self.logo_view.layer.cornerRadius = 10
            self.logo.layer.cornerRadius = 8
            self.card_view_height.constant = 450
            self.card_view_width.constant = 315
            self.view.layoutIfNeeded()
        }, completion: { finish in
            if finish == true {
                self.performSegue(withIdentifier: "finish_launch_animation", sender: self)
            }
        })
    }
}
