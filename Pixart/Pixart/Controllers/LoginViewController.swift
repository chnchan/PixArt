//
//  LoginViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        // Login API { if error != nil
        self.performSegue(withIdentifier: "login", sender: nil)
        // }
    }
}
