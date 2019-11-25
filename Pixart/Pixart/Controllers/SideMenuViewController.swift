//
//  ViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu

protocol SideMenuViewControllerDelegate {
    func dismissSideMenu()
}

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    var delegate: SideMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alias = LocalStorage.fetchAlias()
        
        if alias.isEmpty {
            username.text = LocalStorage.fetchEmail()
        } else {
            username.text = alias
        }
        
        profile_image.layer.masksToBounds = true
        profile_image.layer.cornerRadius = profile_image.bounds.width / 2
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "logout", sender: nil)
    }
}

