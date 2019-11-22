//
//  WorksPrivateViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/14/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class WorksPrivateViewController: UIViewController { // Works saved on local device

    @IBOutlet weak var worksTableView: UITableView!
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var storageRef = StorageReference.init()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    var works: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worksTableView.dataSource = self
        worksTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    private func fetch() {
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
            self.db.collection(self.userID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    //showing everything on the storage
                    //just for debugging
                    print("all things on db")
                    var temps : [[String: Any]] = []
                    for document in querySnapshot!.documents {
                            temps.append(document.data())
                    }
                    
                    print("private works")
                    self.works = []
                    // this force unwrap is what is used in the
                    // cloud firestore docs
                    for document in querySnapshot!.documents {
                        if(document.data()["public"] as? Int == 0 && document.data()["colors"] as? [String:String] != nil)
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

extension WorksPrivateViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        fetch()
    }
}

extension WorksPrivateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worksTableView.dequeueReusableCell(withIdentifier: "private_post") as! PrivateTableViewCell
        let gridSize = (works[indexPath.row])["gridSize"] as! Int
        let colors: [String:String] = (works[indexPath.row])["colors"] as! [String:String]
        cell.preview.makeCells(size: gridSize, data: colors)
        cell.title.text = (works[indexPath.row])["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "WorksDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "workdetail") as! WorksDetailViewController
        vc.modalTransitionStyle = .coverVertical
        vc.work = works[indexPath.row]
        vc.presentationController?.delegate = self
        self.present(vc, animated: true)
    }
}

