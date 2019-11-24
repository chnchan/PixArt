//
//  TrashDetailViewController.swift
//  Pixart
//
//  Created by jizhi on 11/23/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class TrashDetailViewController: UIViewController {

    
    
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    
    var work_UUID: String = ""
    var work_name: String = ""
    var canvas_size: Int = 8
    var colors: [String : String] = [:]
    @IBOutlet weak var preview: CanvasPreview!
    @IBOutlet weak var workname: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.workname.text = self.work_name
        self.preview.makeCells(size: canvas_size, data: colors)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // force unwrap justified since handle will never be nil after
        // viewWillAppear called  (can only get to this view with authenticated
        // user)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func Restore(_ sender: UIButton) {
        self.db.collection(self.userID).document(self.work_UUID).updateData(["public" : 0], completion: {error in
            if error != nil {
                print("error updating data")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    @IBAction func Delete(_ sender: UIButton) {
        self.db.collection(self.userID).document(self.work_UUID).delete(completion: {error in
            if error != nil {
                print("error deleting")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}
