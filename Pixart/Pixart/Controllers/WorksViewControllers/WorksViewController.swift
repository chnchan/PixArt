//
//  WorksViewController2.swift
//  Pixart
//
//  Created by Hin Chan on 11/14/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class WorksViewController: UIViewController {

    @IBOutlet weak var options: UISegmentedControl!
    @IBOutlet weak var publicTable: UITableView!
    @IBOutlet weak var privateTable: UITableView!
    @IBOutlet weak var publishedView_X_constraint: NSLayoutConstraint!
    @IBOutlet weak var privateView_X_constraint: NSLayoutConstraint!
    
    var privateWorks: [[String: Any]] = []
    var publicWorks: [[String: Any]] = []
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privateTable.dataSource = self
        privateTable.delegate = self
        publicTable.dataSource = self
        publicTable.delegate = self
        fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? WorksDetailViewController {
            let work = segue.identifier == "works_detail_published" ? publicWorks[index] : privateWorks[index]
            dest.presentationController?.delegate = self
            dest.work_UUID = work["documentdata"] as? String ?? ""
            dest.work_name = work["name"] as? String ?? ""
            dest.published = work["public"] as! Int
            dest.canvas_size = work["gridSize"] as! Int
            dest.colors = work["colors"] as! [String:String]
        }
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showPrivateView()
            break
        case 1:
            showPublishedView()
            break
        default:
            print("Unknown segment index.")
        }
    }
    
    @IBAction func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizer.Direction.right {
            options.selectedSegmentIndex = 0
            switchViews(options)
        } else if sender.direction == UISwipeGestureRecognizer.Direction.left {
            options.selectedSegmentIndex = 1
            switchViews(options)
        }
        
        return
    }
    
    @IBAction func newPressed(_ sender: Any) {
        performSegue(withIdentifier: "works_to_canvas", sender: self)
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
    
    private func fetch() {
        self.privateWorks = []
        self.publicWorks = []
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
            self.db.collection(self.userID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    // this force unwrap is what is used in the
                    // cloud firestore docs
                    for document in querySnapshot!.documents {
                        if(document.data()["colors"] as? [String:String] != nil) {
                            if(document.data()["public"] as? Int == 0) {
                                self.privateWorks.append(document.data())
                            }
                            if(document.data()["public"] as? Int == 1) {
                               self.publicWorks.append(document.data())
                            }
                        }
                    }
                    
                    self.privateTable.reloadData()
                    self.publicTable.reloadData()
                }
            }
        }
    }
    
    // MARK: Unwind
    @IBAction func unwindToWorks(_ unwindSegue: UIStoryboardSegue) {
        fetch()
    }
}

extension WorksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == publicTable {
            return publicWorks.count
        }
        if tableView == privateTable{
            return privateWorks.count
        }
        print("size 0")
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == publicTable {
            let cell = publicTable.dequeueReusableCell(withIdentifier: "published_post") as! PublishedTableViewCell
            let gridSize = (publicWorks[indexPath.row])["gridSize"] as! Int
            
            let colors: [String:String] = (publicWorks[indexPath.row])["colors"] as! [String:String]
            cell.preview.makeCells(size: gridSize, data: colors)
            cell.title.text = (publicWorks[indexPath.row])["name"] as? String
            cell.likes.text = "0"
            cell.dislikes.text = "0"
            return cell
        }
        
        if tableView == privateTable {
            let cell = privateTable.dequeueReusableCell(withIdentifier: "private_post") as! PrivateTableViewCell
            let gridSize = (privateWorks[indexPath.row])["gridSize"] as! Int
            let colors: [String:String] = (privateWorks[indexPath.row])["colors"] as! [String:String]
            cell.preview.makeCells(size: gridSize, data: colors)
            cell.title.text = (privateWorks[indexPath.row])["name"] as? String
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        
        if tableView == publicTable {
            performSegue(withIdentifier: "works_detail_published", sender: self)
        }
        if tableView == privateTable {
            performSegue(withIdentifier: "works_detail_private", sender: self)
        }
    }
}

extension WorksViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("will dismissed")
        fetch()
    }
}
