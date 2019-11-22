//
//  WorksPublishedViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/14/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class WorksPublishedViewController: UIViewController {

    @IBOutlet weak var worksTableView: UITableView!
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var storageRef = StorageReference.init()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    var works: [[String: Any]] = []
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worksTableView.dataSource = self
        worksTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // force unwrap justified since handle will never be nil after
        // viewWillAppear called  (can only get to this view with authenticated
        // user)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? WorksDetailViewController {
            dest.presentationController?.delegate = self
            dest.work_UUID = self.works[index]["documentdata"] as? String ?? ""
            dest.work_name = self.works[index]["name"] as? String ?? ""
            dest.published = self.works[index]["public"] as! Int
            dest.canvas_size = self.works[index]["gridSize"] as! Int
            dest.colors = self.works[index]["colors"] as! [String:String]
        }
    }
    
    private func fetch() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
            self.db.collection(self.userID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("public works")
                    self.works = []
                    // this force unwrap is what is used in the
                    // cloud firestore docs
                    for document in querySnapshot!.documents {
                        if(document.data()["public"] as? Int == 1 && document.data()["colors"] as? [String:String] != nil)
                        {
                            self.works.append(document.data())
                        }
                    }
                }
                self.worksTableView.reloadData()
            }
        }
    }
}

extension WorksPublishedViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        fetch()
    }
}

extension WorksPublishedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worksTableView.dequeueReusableCell(withIdentifier: "published_post") as! PublishedTableViewCell
        let gridSize = (works[indexPath.row])["gridSize"] as! Int
        
        let colors: [String:String] = (works[indexPath.row])["colors"] as! [String:String]
        cell.preview.makeCells(size: gridSize, data: colors)
        cell.title.text = (works[indexPath.row])["name"] as? String
        cell.likes.text = "10"
        cell.dislikes.text = "10"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        performSegue(withIdentifier: "works_detail_published", sender: self)
    }
}

