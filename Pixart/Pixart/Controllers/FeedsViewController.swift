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
    let canvas_width = CGFloat(Application.device_width) - 20 - 20 - 17 - 17 - 5 - 5
    var handle: AuthStateDidChangeListenerHandle?
    var curr_workID: String = ""
    var publicWorks: [[String: Any]] = []
    var canvas_size : Int = 8
    var colors: [String : String] = [:]

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
        overrideUserInterfaceStyle = .light
        let left_swipe = UISwipeGestureRecognizer(target: self, action: #selector(gestureHandler(gesture:)))
        let right_swipe = UISwipeGestureRecognizer(target: self, action: #selector(gestureHandler(gesture:)))
        left_swipe.direction = .left
        right_swipe.direction = .right
        view.addGestureRecognizer(left_swipe)
        view.addGestureRecognizer(right_swipe)
        card_view.addShadow(x: 0.5, y: 5)
        card_view_top.constant = -600
        swipe_left_icon.addShadow()
        swipe_right_icon.addShadow()
        Application.current_VC = self
        fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ImageViewController {
            dest.work_name = work_name.text ?? ""
            dest.canvas_size = self.canvas_size
            dest.colors = self.colors
        }
    }
    
    @IBAction func zoomImage(_ sender: Any) {
        performSegue(withIdentifier: "image_only2", sender: self)
    }
    
    @IBAction func like(_ sender: Any) {
        print("like!")
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: Application.transition_speed, animations: {
            self.card_view_left.constant = 420
            self.card_view_right.constant = -380
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.db.collection(self.authorID).document(self.workID).updateData(["likes" : FieldValue.increment(Int64(1))])
                self.db.collection("PublishedWorks").document(self.workID).updateData(["likes" : FieldValue.increment(Int64(1))])
                self.fetch()
            }
        })
    }

    @IBAction func pass(_ sender: Any) {
        print("pass!")
        view.isUserInteractionEnabled = false
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
                let author = document!["author"] as! String
                let date = document!["date"] as! String
                self.colors = document!["colors"] as! [String:String]
                self.canvas_size = document!["gridSize"] as! Int

                if (self.publicWorks.count == 1 || self.workID != self.curr_workID) {
                    self.curr_workID = self.workID
                    self.preview.makeCells(size: self.canvas_size, data: self.colors, canvasWidth: self.canvas_width)
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
        }, completion: { _ in
            self.view.isUserInteractionEnabled = true
        })
    }
}
