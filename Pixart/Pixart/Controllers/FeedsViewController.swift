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
    
    @IBOutlet weak var card_view: UIView!
    @IBOutlet weak var card_view_top: NSLayoutConstraint!
    @IBOutlet weak var card_view_left: NSLayoutConstraint!
    @IBOutlet weak var card_view_right: NSLayoutConstraint!
    @IBOutlet weak var swipe_view: UIView!
    @IBOutlet weak var swipe_left_icon: UIView!
    @IBOutlet weak var swipe_right_icon: UIView!
    @IBOutlet weak var preview: CanvasPreview!
    @IBOutlet weak var work_name: UILabel!
    @IBOutlet weak var author_name: UILabel!
    @IBOutlet weak var publish_date: UILabel! // MARK: READ ME!! This should be the first publish date. To prevent exploit like refreshing the timestamp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let left_swipe = UISwipeGestureRecognizer(target: self, action: #selector(gestureHandler(gesture:)))
        let right_swipe = UISwipeGestureRecognizer(target: self, action: #selector(gestureHandler(gesture:)))
        left_swipe.direction = .left
        right_swipe.direction = .right
        swipe_view.addGestureRecognizer(left_swipe)
        swipe_view.addGestureRecognizer(right_swipe)
        card_view.addShadow(x: 0.5, y: 5)
        card_view_top.constant = -600
        swipe_left_icon.addShadow()
        swipe_right_icon.addShadow()
        Application.current_VC = self
//        fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: Application.transition_speed + 0.2, animations: {
            self.card_view_top.constant = 61
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func like(_ sender: Any) {
        print("like!")
        UIView.animate(withDuration: Application.transition_speed, animations: {
            self.card_view_left.constant = 420
            self.card_view_right.constant = -380
            self.view.layoutIfNeeded()
        })
        //fetch next
    }
    
    @IBAction func pass(_ sender: Any) {
        print("pass!")
        UIView.animate(withDuration: Application.transition_speed, animations: {
            self.card_view_left.constant = -380
            self.card_view_right.constant = 420
            self.view.layoutIfNeeded()
        })
        //fetch next
    }
    
    @objc func gestureHandler(gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            if gesture.direction == UISwipeGestureRecognizer.Direction.right {
                like(self)
            } else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
                pass(self)
            }
        }
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
                    self.preview.makeCells(size: gridSize, data: gridColors)
                    print("hello")
                }
            }
        }
    }
}
