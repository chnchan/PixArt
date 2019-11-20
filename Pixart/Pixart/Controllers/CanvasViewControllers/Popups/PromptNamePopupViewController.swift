//
//  PromptNamePopupViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/17/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class PromptNamePopupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.delegate = self
        name.becomeFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CanvasViewController {
            dest.artwork_name = name.text ?? "No Name"
        }
    }
    
    @IBAction func done(_ sender: Any?) {
        view.endEditing(true)
        performSegue(withIdentifier: "unwind_canvas2", sender: self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        done(nil)
        return true
    }
}
