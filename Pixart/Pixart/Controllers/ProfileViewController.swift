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
    @IBOutlet weak var card_view: UIView!
    @IBOutlet weak var options: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupSideMenu()
        card_view.addShadow()
        email.setLeftImage(systemImage: "envelope", cornerRadius: CORNER_RADIUS)
        email.layer.borderColor = UIColor.lightGray.cgColor
        email.layer.borderWidth = 0.2
        email.layer.cornerRadius = CORNER_RADIUS
        alias.setLeftImage(systemImage: "person", cornerRadius: CORNER_RADIUS)
        alias.layer.borderColor = UIColor.lightGray.cgColor
        alias.layer.borderWidth = 0.2
        alias.layer.cornerRadius = CORNER_RADIUS
        alias.delegate = self
    }
    
    @IBAction func updateCanvasSize(_ sender: UISegmentedControl) {
        LocalStorage.saveCanvasSize(size: Application.canvas_sizes[options.selectedSegmentIndex])
    }
    
    @IBAction func updateAlias(_ sender: Any) {
        LocalStorage.saveAlias(alias: alias.text ?? "")
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        view.endEditing(true)
        performSegue(withIdentifier: "profile_to_sidemenu", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        performSegue(withIdentifier: "unwind_profile_to_login", sender: self)
    }
    
    private func setupSideMenu() {
        if Application.sidemenu_initialized == false {
            Application.sidemenu_initialized = true
            let storyboard = UIStoryboard(name: "SideMenu", bundle: nil)
            SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
            SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        }
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
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
