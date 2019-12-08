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

    let CORNER_RADIUS: CGFloat = 20
    
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var alias: UITextField!
    @IBOutlet weak var options: UISegmentedControl!
    @IBOutlet weak var launch_options: UISegmentedControl!
    @IBOutlet weak var card_view: UIView!
    @IBOutlet weak var card_view_centerX: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        loadData()
        card_view.addShadow()
        card_view_centerX.constant = 416
        
        email.setLeftImage(systemImage: "envelope", cornerRadius: CORNER_RADIUS)
        email.layer.borderColor = UIColor.lightGray.cgColor
        email.layer.borderWidth = 0.2
        email.layer.cornerRadius = CORNER_RADIUS
        
        alias.setLeftImage(systemImage: "person", cornerRadius: CORNER_RADIUS)
        alias.layer.borderColor = UIColor.lightGray.cgColor
        alias.layer.borderWidth = 0.2
        alias.layer.cornerRadius = CORNER_RADIUS
    
        Application.current_VC = self
        alias.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: Application.transition_speed, animations: {
            self.card_view_centerX.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func updateLocalStorage(_ sender: Any) {
        LocalStorage.saveProfileSettings(alias: alias.text ?? "", size: Application.canvas_sizes[options.selectedSegmentIndex], option: launch_options.selectedSegmentIndex)
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        view.endEditing(true)
        performSegue(withIdentifier: "profile_to_sidemenu", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        LocalStorage.disableAutoLogin()
        performSegue(withIdentifier: "logout_present_profile", sender: self)
//        performSegue(withIdentifier: "unwind_profile_to_login", sender: self)
    }
    
    private func loadData() {
        let size = LocalStorage.fetchCanvasSize()
        email.text = LocalStorage.fetchEmail()
        alias.text = LocalStorage.fetchAlias()
        
        if size == Application.canvas_sizes[0] {
            options.selectedSegmentIndex = 0
        } else if size == Application.canvas_sizes[1] {
            options.selectedSegmentIndex = 1
        } else if size == Application.canvas_sizes[2] {
            options.selectedSegmentIndex = 2
        } else if size == Application.canvas_sizes[3] {
            options.selectedSegmentIndex = 3
        } else {
            print("Unknown canvas size!")
        }
        
        if LocalStorage.fetchLaunchOption() == 1 {
            launch_options.selectedSegmentIndex = 1
        } else {
            launch_options.selectedSegmentIndex = 0
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
