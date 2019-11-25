//
//  LoginViewController2.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu
import GoogleSignIn
import FirebaseAuth

var safeArea_top: Int = 0
var sidemenu_initialized: Bool = false

class LoginViewController: UIViewController {
    
    let CORNER_RADIUS: CGFloat = 20
    // Login
    @IBOutlet weak var card_view: UIView!
    @IBOutlet weak var login_view: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var login_button: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var card_view_X_constraint: NSLayoutConstraint!
    // Signup
    @IBOutlet weak var signup_view: UIView!
    @IBOutlet weak var signup_email: UITextField!
    @IBOutlet weak var signup_password: UITextField!
    @IBOutlet weak var confirm_password: UITextField!
    @IBOutlet weak var signup_errorLabel: UILabel!
    @IBOutlet weak var signup_button: UIButton!
    @IBOutlet weak var signup_spinner: UIActivityIndicatorView!
    @IBOutlet weak var signup_X_constraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        signup_view.addShadow()
        card_view.addShadow()
        login_view.alpha = 0
        email.layer.cornerRadius = CORNER_RADIUS
        email.layer.borderColor = UIColor.lightGray.cgColor
        email.layer.borderWidth = 0.2
        email.setLeftImage(systemImage: "envelope", cornerRadius: CORNER_RADIUS)
        password.layer.cornerRadius = CORNER_RADIUS
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.borderWidth = 0.2
        password.setLeftImage(systemImage: "lock", cornerRadius: CORNER_RADIUS)
        signup_email.addLeftPadding(width: 20)
        signup_password.addLeftPadding(width: 20)
        confirm_password.addLeftPadding(width: 20)
        email.delegate = self
        password.delegate = self
        signup_email.delegate = self
        signup_password.delegate = self
        confirm_password.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        signup_password.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit, [-().&@?'#,/&quot;+]; minlength: 7;")
        
        UIView.animate(withDuration: 0.3, animations: {
            self.login_view.alpha = 1
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        card_view_X_constraint.constant = 0
        signup_X_constraint.constant = 416
        
        if let userInfo = LocalStorage.fetchLogins() {
            if (!userInfo.isEmpty) {
                email.text = userInfo[0].value(forKey: "username") as? String
                password.text = userInfo[0].value(forKey: "password") as? String
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        safeArea_top = Int(view.safeAreaInsets.top) // for color slider later
        sidemenu_initialized = false
        SideMenuManager.default.leftMenuNavigationController = nil
        SideMenuManager.default.rightMenuNavigationController = nil
    }
    
    @IBAction func loginRequested(_ sender: Any) {
        self.view.endEditing(true)
        self.spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.login_button.backgroundColor = UIColor.lightGray
        
        ServerAPI.login(email: email.text ?? "", password: password.text ?? "") { response, error in
            self.spinner.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.login_button.backgroundColor = UIColor.systemGreen
            
            if error != nil {
                self.errorLabel.text = error
            } else {
                self.errorLabel.text = ""
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
    }
    
    @IBAction func signupRequested() {
        self.view.endEditing(true)
        self.signup_spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.login_button.backgroundColor = UIColor.lightGray
        
        if !self.validateEmail() {
            signup_errorLabel.text = "Invalid Email."
            self.signup_spinner.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.login_button.backgroundColor = UIColor.systemGreen
            
        } else if signup_password.text != confirm_password.text {
            signup_errorLabel.text = "Passwords do not match."
            self.signup_spinner.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.login_button.backgroundColor = UIColor.systemGreen
        } else if !self.validatePassword() {
            signup_errorLabel.text = "Password doesn't meet requirements."
            self.signup_spinner.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.login_button.backgroundColor = UIColor.systemGreen
        }
        else {
            Auth.auth().createUser(withEmail: signup_email.text ?? "", password: signup_password.text ?? "") { authResult, error in
                self.signup_spinner.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.login_button.backgroundColor = UIColor.systemGreen
                
                if error != nil {
                    self.signup_errorLabel.text = "Account with email already exists."
                } else {
                    self.signup_errorLabel.text = ""
                    LocalStorage.saveLogins(username: self.signup_email.text ?? "", password: self.signup_password.text ?? "")
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    @IBAction func showSignup(_ sender: Any) {
        signup_email.text = ""
        signup_password.text = ""
        confirm_password.text = ""
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.signup_X_constraint.constant = 0
            self.card_view_X_constraint.constant = -416
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished == true {
                self.view.isUserInteractionEnabled = true
            }
        })
    }
    
    @IBAction func showLogin(_ sender: Any) {
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.signup_X_constraint.constant = 416
            self.card_view_X_constraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished == true {
                self.view.isUserInteractionEnabled = true
            }
        })
    }
    
    private func validatePassword() -> Bool {
        // Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
        // Pavits97!
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: signup_password.text)
    }

    private func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: signup_email.text)
    }
    
    // MARK: UNWIND
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
