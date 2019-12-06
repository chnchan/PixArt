//
//  ViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    
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
    
    @IBAction func profilePressed(_ sender: Any) {
        if Application.current_VC is ProfileViewController {
            dismiss(animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "profile", sender: nil)
        }
    }
    
    @IBAction func canvasPressed(_ sender: Any) {
        if Application.current_VC is CanvasViewController {
            dismiss(animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "canvas", sender: nil)
        }
    }
    
    @IBAction func worksPressed(_ sender: Any) {
        if Application.current_VC is WorksViewController {
            dismiss(animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "works", sender: nil)
        }
    }
    
    @IBAction func browsePressed(_ sender: Any) {
        if Application.current_VC is FeedsViewController {
            dismiss(animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "feeds", sender: nil)
        }
    }
    
    @IBAction func popularPressed(_ sender: Any) {
        if Application.current_VC is PopularViewController {
                  dismiss(animated: true, completion: nil)
              } else {
                  self.performSegue(withIdentifier: "popular", sender: nil)
        }
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        LocalStorage.disableAutoLogin()
        self.performSegue(withIdentifier: "logout_present_sidemenu", sender: nil)
//        self.performSegue(withIdentifier: "logout", sender: nil)
    }
}

