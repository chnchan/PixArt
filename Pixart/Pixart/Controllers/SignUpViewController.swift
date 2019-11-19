//
//  SignUpViewController.swift
//  Pixart
//
//  Created by Pavit Bath on 11/13/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm_password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        password.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit, [-().&@?'#,/&quot;+]; minlength: 7;")
    }
    
    @IBAction func backPressed() {
        performSegue(withIdentifier: "backToLogin", sender: self)
    }
    private func validatePassword() -> Bool {
        // Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
        // Pavits97!
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password.text)
    }
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email.text)
    }
    
    @IBAction func sendPressed() {
        sendButton.isUserInteractionEnabled = false
        if !self.validateEmail() {
            errorLabel.text = "Email not valid"
            self.sendButton.isUserInteractionEnabled = true
            
        } else if password.text != confirm_password.text {
            errorLabel.text = "passwords do not match"
            self.sendButton.isUserInteractionEnabled = true
        } else if !self.validatePassword() {
            errorLabel.text = "Password doesn't meet requirements"
            self.sendButton.isUserInteractionEnabled = true
        }
        else {
            Auth.auth().createUser(withEmail: email.text ?? "", password: password.text ?? "") { authResult, error in
                self.sendButton.isUserInteractionEnabled = true
                if error != nil {
                    self.errorLabel.text = "Account with email already exists"
                } else {
                    self.errorLabel.text = ""
                    LocalStorage.saveLogins(username: self.email.text ?? "", password: self.password.text ?? "")
                    self.performSegue(withIdentifier: "signin", sender: self)
                }

            }
        }
        
    }
}
