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

    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var options: UISegmentedControl!
    let canvas_size: [Int] = [8, 16, 32, 64]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile_image.layer.masksToBounds = true
        profile_image.layer.cornerRadius = profile_image.bounds.width / 2
        setupSideMenu()
        loadData()
    }
    
    @IBAction func updateCanvasSize(_ sender: UISegmentedControl) {
        LocalStorage.saveCanvasSize(size: canvas_size[options.selectedSegmentIndex])
    }
    
    private func setupSideMenu() {
        let storyboard = UIStoryboard(name: "SideMenu", bundle: nil)
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }
    
    private func loadData() {
        let size = LocalStorage.fetchCanvasSize()
        
        if let userInfo = LocalStorage.fetchLogins(){
            if(!userInfo.isEmpty) {
                username.text = userInfo[0].value(forKey: "username") as? String
            }
            else{
                username.text = "Anonymous"
            }
        }
        
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
