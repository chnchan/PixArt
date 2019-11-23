//
//  FeedsViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu
import Firebase

class FeedsViewController: UIViewController {

    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var publicWorks: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        image.layer.borderWidth = 5
//        image.layer.borderColor = UIColor.gray.cgColor
        // Do any additional setup after loading the view.
        fetch()
    }
    
    private func fetch() {
        self.db.collection("PublishedWorks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // this force unwrap is what is used in the
                // cloud firestore docs
                for document in querySnapshot!.documents {
                    if(document.data()["userID"] as? String != nil) {
                        self.publicWorks.append(document.data())
                    }
                }
                self.publicWorks.shuffle()
                self.getDrawing()
            }
        }
    }
    
    private func getDrawing() {
        for work in publicWorks {
            let workAuthor = work["userID"] as! String
            let workID = work["workID"] as! String
            self.db.collection(workAuthor).document(workID).getDocument() { (document, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let gridColors = document!["colors"] as! [String:String]
                    let gridSize = document!["gridSize"] as! Int
//                    self.preview.makeCells(size: gridSize, data: gridColors)
                    print("hello")
                }
            }
        }
    }
    
}
