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
    var curr_workID: String = ""
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
    @IBOutlet weak var publish_date: UILabel!
    
    var authorID = String()
    var workID = String()

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
        fetch()
    }
    
    @IBAction func like(_ sender: Any) {
        print("like!")
        UIView.animate(withDuration: Application.transition_speed, animations: {
            self.card_view_left.constant = 420
            self.card_view_right.constant = -380
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.giveALike()
               
            }
        })
    }

    @IBAction func pass(_ sender: Any) {
        print("pass!")
        UIView.animate(withDuration: Application.transition_speed, animations: {
            self.card_view_left.constant = -380
            self.card_view_right.constant = 420
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.fetch()
            }
        })
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
        self.card_view_top.constant = -600
        self.card_view_left.constant = 20
        self.card_view_right.constant = 20
        self.publicWorks = []
        
        self.db.collection("PublishedWorks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if(document.data()["userID"] as? String != nil) {
                        self.publicWorks.append(document.data())
                    }
                }
                
                self.updateData()
            }
        }
    }

    private func updateData() {
        if (publicWorks.count == 0) {
            return
        }
        
        self.publicWorks.shuffle()
        authorID = publicWorks[0]["userID"] as! String
        workID = publicWorks[0]["workID"] as! String
        //print(workID)
        //print(publicWorks.count)
        
        db.collection(authorID).document(workID).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let name = document!["name"] as! String
                let gridColors = document!["colors"] as! [String:String]
                let gridSize = document!["gridSize"] as! Int
                let author = document!["author"] as! String
                let date = document!["date"] as! String

                if (self.publicWorks.count == 1 || self.workID != self.curr_workID) {
                    self.curr_workID = self.workID
                    self.preview.makeCells(size: gridSize, data: gridColors)
                    self.work_name.text = name
                    self.author_name.text = author
                    self.publish_date.text = "Published on " + date
                    self.showCard()
                } else {
                    self.updateData() // same art recieved. Try to get another one.
                }
            }
        }
    }
    
    private func showCard() {
        UIView.animate(withDuration: Application.transition_speed + 0.2, animations: {
            self.card_view_top.constant = 61
            self.view.layoutIfNeeded()
        })
    }
    
    private func giveALike(){
        
        var currentLikes = 0
        // Get how many likes a user has
        db.collection(authorID).document(workID).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            let likes = document!["likes"] as? Int
            if let likes = likes {
                currentLikes = likes + 1
                // update likes
                self.db.collection(self.authorID).document(self.workID).updateData(["likes": currentLikes]) {err in
                    if let err = err {
                           print("Error updating likes: \(err)")
                           return
                    }
                    self.fetch()
                }
            }
        }
    }
    
    
}
