//
//  WorkDetailViewController.swift
//  Pixart
//
//  Created by jizhi on 11/16/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class WorksDetailViewController: UIViewController , UITextFieldDelegate{

    

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var private_icon: UIView!
    @IBOutlet weak var published_icon: UIView!
    @IBOutlet weak var privateView_X_constraint: NSLayoutConstraint!
    @IBOutlet weak var publishedView_X_constraint: NSLayoutConstraint!
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var storageRef = StorageReference.init()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    var work: [String: Any] = [:]
    var documentdata : String = ""
    @IBOutlet weak var workname: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
        self.workname.delegate = self
        self.documentdata = work["documentdata"] as? String ?? ""
        self.workname.text = work["name"] as? String
        
        if (work["public"] as? Int == 0) {
            published_icon.alpha = 0
            publishedView_X_constraint.constant = 416
        } else {
            private_icon.alpha = 0
            privateView_X_constraint.constant = -416
        }
        
        let drawingref = storageRef.child(work["gridFilePath"] as! String)
        let gridSize = work["gridSize"] as! Int
        drawingref.getData(maxSize: 1*1024*1024) {data, error in
            if error != nil{
                print("error getting image")
            } else {
                  do {
                      let gridCells = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as? [String:UIView]
                    self.gridView.makeCells(size: gridSize, cells: gridCells!)
                    self.container.isHidden = false
                    self.gridView.isHidden = false

                  } catch {
                      fatalError("Can't encode data: \(error)")
                  }
            }
        }
    }
    
    @IBAction func updateName(_ sender: UITextField) {
        guard let newname = self.workname.text else{
            return
        }
        self.db.collection(self.userID).document(self.documentdata).setData(["name" : newname], mergeFields: ["name"])
    }
    
    @IBAction func publish(_ sender: Any) {
        self.db.collection(self.userID).document(self.documentdata).setData([
        "public" : 1], mergeFields: ["public"])
        
        showPublishedIcon()
        showPublishedView()
    }
    
    @IBAction func removePublished(_ sender: Any) {
        self.db.collection(self.userID).document(self.documentdata).setData([
        "public" : 0], mergeFields: ["public"])
        showPrivateIcon()
        showPrivateView()
    }
    
    @IBAction func deletebutton(_ sender: UIButton) {
        self.db.collection(self.userID).document(self.documentdata).delete(completion: {error in
            if error != nil {
                print("error deleting")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func showPrivateIcon() {
        UIView.animate(withDuration: 0.3, animations:{
            self.private_icon.alpha = 1
            self.published_icon.alpha = 0
        })
    }
    
    private func showPublishedIcon() {
        UIView.animate(withDuration: 0.3, animations:{
            self.private_icon.alpha = 0
            self.published_icon.alpha = 1
        })
    }
    
    private func showPrivateView() {
        UIView.animate(withDuration: 0.3, animations:{
            self.publishedView_X_constraint.constant = 416
            self.privateView_X_constraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    private func showPublishedView() {
        UIView.animate(withDuration: 0.3, animations:{
            self.publishedView_X_constraint.constant = 0
            self.privateView_X_constraint.constant = -416
            self.view.layoutIfNeeded()
        })
    }
}
