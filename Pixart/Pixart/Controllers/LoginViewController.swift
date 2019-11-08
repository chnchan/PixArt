//
//  LoginViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu

var sideMenuInitialized: Bool = false

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Credits", bundle: nil)
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "CreditMenuNavigationController") as? SideMenuNavigationController
        
        if sideMenuInitialized == false {
            setupSideMenu()
        }
    }
    
    private func setupSideMenu() {
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        // Login API { if error != nil
        self.performSegue(withIdentifier: "login", sender: nil)
        // }
    }
}
