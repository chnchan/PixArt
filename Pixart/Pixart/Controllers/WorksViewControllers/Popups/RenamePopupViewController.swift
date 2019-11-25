//
//  PromptNamePopupViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/24/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class RenamePopupViewController: UIViewController, UITextFieldDelegate {

    let db = Firestore.firestore()
    var userID = ""
    var work_UUID: String = ""
    var work_name: String = "No Name"
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var popup_view: UIView!
    @IBOutlet weak var centerX: NSLayoutConstraint!
    @IBOutlet var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.delegate = self
        self.name.placeholder = work_name
        self.centerX.constant = -416
        self.popup_view.addShadow(radius: 0.5)
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
        if let dest = segue.destination as? WorksDetailViewController {
            dest.work_name = (name.text ?? "").isEmpty ? work_name : name.text ?? ""
        }
    }
    
    @IBAction func done(_ sender: Any?) {
        view.endEditing(true)
        
        if name.text != "" && name.text != work_name {
            self.db.collection(self.userID).document(self.work_UUID).setData(["name" : name.text ?? ""], mergeFields: ["name"])
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.centerX.constant = 416
            self.background.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished == true {
                self.performSegue(withIdentifier: "unwind_works_detail2", sender: self)
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
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        done(nil)
        return true
    }
}
