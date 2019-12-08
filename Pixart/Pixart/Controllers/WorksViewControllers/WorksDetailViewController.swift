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

    let db = Firestore.firestore()
    let canvas_width = CGFloat(Application.device_width) - 17 - 17 - 5 - 5
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    
    var work_UUID: String = ""
    var work_name: String = ""
    var published: Int = 0
    var canvas_size: Int = 8
    var colors: [String : String] = [:]
    var likes : Int = 0
    
    @IBOutlet weak var workname: UIButton!
    @IBOutlet weak var edit_button: UIButton!
    @IBOutlet weak var editButton_Y_top: NSLayoutConstraint!
    @IBOutlet weak var likesField: UILabel!
    @IBOutlet weak var likes_Y_top: NSLayoutConstraint!
    @IBOutlet weak var preview: CanvasPreview!
    @IBOutlet weak var private_icon: UIView!
    @IBOutlet weak var published_icon: UIView!
    @IBOutlet weak var privateView_X_constraint: NSLayoutConstraint!
    @IBOutlet weak var publishedView_X_constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
        self.workname.setTitle(self.work_name, for: .normal)
        self.likesField.text = "\(likes)"
        self.preview.makeCells(size: canvas_size, data: colors, canvasWidth: canvas_width)
        
        if (self.published == 0) {
            self.published_icon.alpha = 0
            self.publishedView_X_constraint.constant = 416
            self.editButton_Y_top.constant = -9
            self.likes_Y_top.constant = -50
        } else {
            self.private_icon.alpha = 0
            self.privateView_X_constraint.constant = -416
            self.editButton_Y_top.constant = -50
            self.likes_Y_top.constant = -9
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? WorksEditingViewController {
            dest.work_UUID = self.work_UUID
            dest.work_name = self.work_name
            dest.canvas_size = self.canvas_size
            dest.colors = self.colors
            dest.likes = self.likes
        }
        
        if let dest = segue.destination as? RenamePopupViewController {
            dest.userID = self.userID
            dest.work_UUID = self.work_UUID
            dest.work_name = self.work_name
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "work_edit", sender: self)
    }
    
    @IBAction func updateName(_ sender: Any) {
        performSegue(withIdentifier: "rename_popup", sender: self)
    }
    
    @IBAction func publish(_ sender: Any) {
        let alias = LocalStorage.fetchAlias()
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMMM dd, yyyy"
        print(dateFormat.string(from: date))
        self.db.collection(self.userID).document(self.work_UUID).setData([
            "author": alias.isEmpty ? "Anonymous" : alias,
            "date": dateFormat.string(from:date),
            "public": 1
        ], mergeFields: ["public", "author", "date"], completion: { error in
            if error != nil {
                print("error updating data")
            } else {
                print("updated")
                self.showPublishedView()
            }
        })

        self.db.collection("PublishedWorks").document(self.work_UUID).setData([
            "userID": self.userID,
            "workID": self.work_UUID,
            "likes": self.likes
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
    @IBAction func removePublished(_ sender: Any) {
        self.db.collection(self.userID).document(self.work_UUID).updateData(["public":0], completion: {error in
            if error != nil {
                print("error updating data")
            } else {
                self.showPrivateView()
            }
        })
        self.db.collection("PublishedWorks").document(self.work_UUID).delete()
    }
    
    @IBAction func saveToPhotos(_ sender: Any) {
        let image = preview.exportToImg().pngData()
        let compressedImage = UIImage(data: image!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Artwork Saved", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deletebutton(_ sender: UIButton) {
        self.db.collection(self.userID).document(self.work_UUID).updateData(["public" : -1], completion: {error in
            if error != nil {
                print("error updating data")
            } else {
                self.performSegue(withIdentifier: "unwind_works", sender: self)
            }
        })
        self.db.collection("PublishedWorks").document(self.work_UUID).delete()
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showPrivateView() {
        self.edit_button.isEnabled = true
        
        UIView.animate(withDuration: 0.3, animations:{
            self.private_icon.alpha = 1
            self.published_icon.alpha = 0
            self.editButton_Y_top.constant = -9
            self.likes_Y_top.constant = -50
            self.publishedView_X_constraint.constant = 416
            self.privateView_X_constraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    private func showPublishedView() {
        self.edit_button.isEnabled = false
        
        UIView.animate(withDuration: 0.3, animations:{
            self.private_icon.alpha = 0
            self.published_icon.alpha = 1
            self.editButton_Y_top.constant = -50
            self.likes_Y_top.constant = -9
            self.publishedView_X_constraint.constant = 0
            self.privateView_X_constraint.constant = -416
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: Unwind
    @IBAction func unwindToWorksDetail(_ unwindSegue: UIStoryboardSegue) {
        workname.setTitle(work_name, for: .normal)
        self.likesField.text = "\(likes)"
        preview.makeCells(size: canvas_size, data: colors, canvasWidth: canvas_width)
    }
}

extension WorksDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
