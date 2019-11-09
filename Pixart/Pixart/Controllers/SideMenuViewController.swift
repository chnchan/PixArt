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
    
    @IBOutlet weak var profile_image: UIImageView!
    var delegate: SideMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile_image.layer.masksToBounds = true
        profile_image.layer.cornerRadius = profile_image.bounds.width / 2
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "profile", sender: nil)
    }
    
    @IBAction func canvasPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "canvas", sender: nil)
    }
    
    @IBAction func worksPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "works", sender: nil)
    }
    
    @IBAction func browsePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "feeds", sender: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "logout", sender: nil)
    }
    
    func printstuff(){
        print("apple")
    }
}

