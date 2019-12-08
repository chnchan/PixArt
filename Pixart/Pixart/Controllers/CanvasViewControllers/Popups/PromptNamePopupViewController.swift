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
    @IBOutlet var background: UIView!
    @IBOutlet weak var centerX: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.centerX.constant = -416
        self.name.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.name.becomeFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.centerX.constant = 0
            self.background.backgroundColor = UIColor.black.withAlphaComponent(0.30)
            self.view.layoutIfNeeded()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CanvasViewController {
            dest.work_name = (name.text ?? "").isEmpty ? "No Name" : name.text ?? ""
        }
    }
    
    @IBAction func done(_ sender: Any?) {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.centerX.constant = 416
            self.background.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished == true {
                self.performSegue(withIdentifier: "unwind_canvas2", sender: self)
            }
        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.centerX.constant = 416
            self.background.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished == true {
                self.performSegue(withIdentifier: "unwind_canvas2_dismiss", sender: self)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        done(nil)
        return true
    }
}
