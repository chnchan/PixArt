//
//  PromptNamePopupViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/17/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class PromptNamePopupViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CanvasViewController {
            dest.artwork_name = name.text ?? "No Name"
        }
    }
    
    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "unwind_canvas2", sender: self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
