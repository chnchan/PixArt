//
//  LoginViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu
import GoogleSignIn
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        if let userInfo = LocalStorage.fetchLogins() {
            if (!userInfo.isEmpty) {
                email.text = userInfo[0].value(forKey: "username") as? String
                password.text = userInfo[0].value(forKey: "password") as? String
            }
        }
    }
    
    private func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = nil
        SideMenuManager.default.rightMenuNavigationController = nil
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text ?? "", password: password.text ?? "") { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if error != nil {
                strongSelf.errorLabel.text = "Invalid Credentials"
            } else {
                strongSelf.errorLabel.text = ""
                LocalStorage.saveLogins(username: strongSelf.email.text ?? "", password: strongSelf.password.text ?? "")
                strongSelf.performSegue(withIdentifier: "login", sender: strongSelf)
            }
        }
    }
    

    @IBAction func signUpPressed() {
        self.performSegue(withIdentifier: "newAcc", sender: self)
        
    }
    
    // MARK: UNWIND
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Credits", bundle: nil)
            SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "CreditMenuNavigationController") as? SideMenuNavigationController
        }
    }
}
