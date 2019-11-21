//
//  WorksPublishedViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/14/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class WorksPublishedViewController: UIViewController { // Works published to FireBase

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // force unwrap justified since handle will never be nil after
        // viewWillAppear called  (can only get to this view with authenticated
        // user)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    private func fetch() {
        // [START auth_listener]
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
                        if(document.data()["public"] as? Int == 1 && document.data()["filePath"] as? String != nil)
                        {
                            self.works.append(document.data())
                        }
                    }
                }
                print(self.works)
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
        // fix force unwrap
        let drawingref = storageRef.child((works[indexPath.row])["gridFilePath"] as! String)

//         Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        drawingref.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if error != nil {
            print("uh oh")
            // Uh-oh, an error occurred!
          } else {
                do {
                    let gridCells = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as? [String:UIView]
                    cell.preview_grid.makeCells(cells: gridCells!)
                    cell.preview_grid.isHidden = false

                } catch {
                    fatalError("Can't encode data: \(error)")
                }
          }
        }
        cell.title.text = (works[indexPath.row])["name"] as? String
        cell.likes.text = "10"
        cell.dislikes.text = "10"
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

