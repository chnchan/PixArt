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
    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile_image.layer.masksToBounds = true
        profile_image.layer.cornerRadius = profile_image.bounds.width / 2
        let storyboard = UIStoryboard(name: "SideMenu", bundle: nil)
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        if let userInfo = LocalStorage.fetchLogins(){
            if(!userInfo.isEmpty) {
                username.text = userInfo[0].value(forKey: "username") as? String
            }
            else{
                username.text = "Anonymous"
            }
        }
    }
}
