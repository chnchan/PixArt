//
//  SettingsPopupViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/17/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class SettingsPopupViewController: UIViewController {

    @IBOutlet weak var options: UISegmentedControl!
    let canvas_size: [Int] = [8, 16, 32, 64]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = LocalStorage.fetchCanvasSize()
        
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
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func apply(_ sender: Any) {
        LocalStorage.saveCanvasSize(size: canvas_size[options.selectedSegmentIndex])
        performSegue(withIdentifier: "unwind_canvas", sender: self)
    }
}
