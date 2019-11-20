//
//  WorkDetailViewController.swift
//  Pixart
//
//  Created by jizhi on 11/16/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class WorkDetailViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var publicbutton: UIButton!
    @IBOutlet weak var image: UIImageView!
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
        if(work["public"] as? Int == 0) {
            self.publicbutton.setTitle("Publish Your Art", for: .normal)
        } else {
            self.publicbutton.setTitle("Set To Private", for: .normal)
        }
        
        let drawingref = storageRef.child(work["filePath"] as! String)
        drawingref.getData(maxSize: 1*1024*1024, completion: {data, error in
            if error != nil{
                print("error getting image")
            } else {
                let image = UIImage(data: data!)
                self.image.image = image
            }
        })
        // Do any additional setup after loading the view.
    }
    @IBAction func backbutton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changename(_ sender: UITextField) {
        guard let newname = self.workname.text else{
            return
        }
        self.db.collection(self.userID).document(self.documentdata).setData(["name" : newname], mergeFields: ["name"])
    }
    
    @IBAction func togglepublicsetting(_ sender: UIButton) {
        var publicsetting : Int = 0
        if sender.currentTitle == "Publish Your Art" {
            print("publicsetting set to public")
            publicsetting = 1
        }
        self.db.collection(self.userID).document(self.documentdata).setData([
            "public" : publicsetting], mergeFields: ["public"])
        if publicsetting == 0 {
            sender.setTitle("Publish Your Art", for: .normal)
        } else {
            sender.setTitle("Set to Private", for: .normal)
        }
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
