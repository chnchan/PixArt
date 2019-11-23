//
//  WorkDetailViewController.swift
//  Pixart
//
//  Created by jizhi on 11/16/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class WorksDetailViewController: UIViewController {

    let storage = Storage.storage()
    let db = Firestore.firestore()
    var storageRef = StorageReference.init()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    var work: [String: Any] = [:]
    
    var work_UUID: String = ""
    var work_name: String = ""
    var published: Int = 0
    var canvas_size: Int = 8
    var colors: [String : String] = [:]
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var preview: CanvasPreview!
    @IBOutlet weak var private_icon: UIView!
    @IBOutlet weak var published_icon: UIView!
    @IBOutlet weak var privateView_X_constraint: NSLayoutConstraint!
    @IBOutlet weak var publishedView_X_constraint: NSLayoutConstraint!
    @IBOutlet weak var workname: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        print("in workview appear")
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
        self.preview.makeCells(size: canvas_size, data: colors)
        
        if (self.published == 0) {
            published_icon.alpha = 0
            publishedView_X_constraint.constant = 416
        } else {
            private_icon.alpha = 0
            privateView_X_constraint.constant = -416
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? WorksEditingViewController {
            dest.work_UUID = self.work_UUID
            dest.work_name = self.work_name
            dest.canvas_size = self.canvas_size
            dest.colors = self.colors
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "work_edit", sender: self)
    }
    
    @IBAction func updateName(_ sender: UITextField) {
        guard let newname = self.workname.text else{
            return
        }
        self.db.collection(self.userID).document(self.work_UUID).setData(["name" : newname], mergeFields: ["name"])
    }
    
    @IBAction func publish(_ sender: Any) {
        /*self.db.collection(self.userID).document(self.work_UUID).setData([
        "public" : 1], mergeFields: ["public"])
        showPublishedIcon()
        showPublishedView()*/
        self.db.collection(self.userID).document(self.work_UUID).updateData(["public":1], completion: {error in
            if error != nil {
                print("error updating data")
            } else {
                print("updated")
                self.showPublishedIcon()
                self.showPublishedView()
            }
        })
    }
    
    @IBAction func removePublished(_ sender: Any) {
        /*self.db.collection(self.userID).document(self.work_UUID).setData([
        "public" : 0], mergeFields: ["public"])
        showPrivateIcon()
        showPrivateView()*/
        self.db.collection(self.userID).document(self.work_UUID).updateData(["public":0], completion: {error in
            if error != nil {
                print("error updating data")
            } else {
                print("updated")
                self.showPrivateIcon()
                self.showPrivateView()
            }
        })
        
    }
    
    @IBAction func deletebutton(_ sender: UIButton) {
        self.db.collection(self.userID).document(self.work_UUID).delete(completion: {error in
            if error != nil {
                print("error deleting")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
        /* When we have trash can implemented
        self.db.collection(self.userID).document(self.documentdata).updateData(["public" : -1], completion: {error in
            if error != nil {
                print("error updating data")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })*/
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    // MARK: Unwind
    @IBAction func unwindToWorksDetail(_ unwindSegue: UIStoryboardSegue) {
        preview.makeCells(size: canvas_size, data: colors)
    }
}

extension WorksDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension WorksDetailViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        
    }
}
