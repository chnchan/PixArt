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
    @IBOutlet weak var swipe_view: UIView!
    @IBOutlet weak var swipe_left_icon: UIView!
    @IBOutlet weak var swipe_right_icon: UIView!
    @IBOutlet weak var preview: CanvasPreview!
    @IBOutlet weak var work_name: UILabel!
    @IBOutlet weak var author_name: UILabel!
    @IBOutlet weak var publish_date: UILabel! // MARK: READ ME!! This should be the first publish date. To prevent exploit like refreshing the timestamp
    
    var currentWorkAuthor = String()
    var currentWorkID = String()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: Application.transition_speed + 0.2, animations: {
            self.card_view_top.constant = 61
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func like(_ sender: Any) {
        print("like!")
        // MARK: TODO
        //like
        fetch()
    }
    
    @IBAction func pass(_ sender: Any) {
        print("pass!")
        // MARK: TODO
        //fetch next
        fetch()
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
        
        if publicWorks.count <= 2{
            return
        }
      
        currentWorkAuthor = publicWorks[0]["userID"] as! String
        currentWorkID = publicWorks[0]["workID"] as! String
        print(currentWorkID)
        print(currentWorkID)

        db.collection(currentWorkAuthor).document(currentWorkID).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                     
                let name = document!["name"] as? String
                print(name)
                let gridColors = document!["colors"] as? [String:String]
                let gridSize = document!["gridSize"] as? Int
                
                if let name = name,  let gridColors = gridColors, let gridSize = gridSize {
                    if self.work_name.text != name {
                        self.preview.makeCells(size: gridSize, data: gridColors)
                        self.work_name.text = name
                        self.author_name.text = "Anonymous"
                        
                    }else{
                        self.requestExtra()
                    }
                }
            }
        }
        
    }
    
    private func requestExtra() {
        currentWorkAuthor = publicWorks[1]["userID"] as! String
        currentWorkID = publicWorks[1]["workID"] as! String
        db.collection(currentWorkAuthor).document(currentWorkID).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let name = document!["name"] as? String
                let gridColors = document!["colors"] as? [String:String]
                let gridSize = document!["gridSize"] as? Int
                
                if let name = name,  let gridColors = gridColors, let gridSize = gridSize {
    
                    self.preview.makeCells(size: gridSize, data: gridColors)
                    self.work_name.text = name
                    self.author_name.text = "Anonymous"
                }
            }
        }
    }
    
    private func like(){
        
        db.collection(currentWorkAuthor).document(currentWorkID).updateData([ "likes" : 1] , completion: { err in
            
        })
    }
}
