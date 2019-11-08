//
//  ProfileViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu

class ProfileViewController: UIViewController {

    @IBOutlet weak var profile_image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile_image.layer.masksToBounds = true
        profile_image.layer.cornerRadius = profile_image.bounds.width / 2
        let storyboard = UIStoryboard(name: "SideMenu", bundle: nil)
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }
}
