//
//  LoginViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseAuth
import FirebaseUI


class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        
        if let userInfo = Storage.fetchLogins() {
            if (!userInfo.isEmpty) {
                username.text = userInfo[0].value(forKey: "username") as? String
                password.text = userInfo[0].value(forKey: "password") as? String
            }
        }
    }
    
    private func setupSideMenu() {
        let storyboard = UIStoryboard(name: "Credits", bundle: nil)
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "CreditMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if true { // API validate logins
            if true { // remember me is on
                Storage.saveLogins(username: username.text ?? "", password: password.text ?? "")
            } else {
                Storage.saveLogins(username: username.text ?? "", password: "")
            }
            
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    

    @IBAction func signUpPressed() {

    }
    
    // MARK: UNWIND
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Credits", bundle: nil)
            SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "CreditMenuNavigationController") as? SideMenuNavigationController
        }
    }
}
