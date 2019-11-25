//
//  SettingsPopupViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/17/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class SettingsPopupViewController: UIViewController {

    let canvas_sizes: [Int] = [8, 16, 32, 64]
    
    var canvas_size: Int = 8
    var background_color: UIColor = UIColor.white
    @IBOutlet weak var options: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if canvas_size == 8 {
            options.selectedSegmentIndex = 0
        } else if canvas_size == 16 {
            options.selectedSegmentIndex = 1
        } else if canvas_size == 32 {
            options.selectedSegmentIndex = 2
        } else if canvas_size == 64 {
            options.selectedSegmentIndex = 3
        } else {
            print("Unknown canvas size!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CanvasViewController {
            dest.canvas_size = canvas_sizes[options.selectedSegmentIndex]
            dest.BACKGROUND_COLOR = UIColor.white
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func apply(_ sender: Any) {
//        LocalStorage.saveCanvasSize(size: canvas_size[options.selectedSegmentIndex])
        performSegue(withIdentifier: "unwind_canvas", sender: self)
    }
}
