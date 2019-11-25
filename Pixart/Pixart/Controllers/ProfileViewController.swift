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
    let canvas_sizes: [Int] = [8, 16, 32, 64]
    
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
        LocalStorage.saveCanvasSize(size: canvas_sizes[options.selectedSegmentIndex])
    }
    
    @IBAction func updateAlias(_ sender: Any) {
        LocalStorage.saveAlias(alias: alias.text ?? "")
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        view.endEditing(true)
        performSegue(withIdentifier: "profile_to_sidemenu", sender: self)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        
    }
    
    private func setupSideMenu() {
        if sidemenu_initialized == false {
            sidemenu_initialized = true
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
        
        if size == 8 {
            options.selectedSegmentIndex = 0
        } else if size == 16 {
            options.selectedSegmentIndex = 1
        } else if size == 32 {
            options.selectedSegmentIndex = 2
        } else if size == 64 {
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
