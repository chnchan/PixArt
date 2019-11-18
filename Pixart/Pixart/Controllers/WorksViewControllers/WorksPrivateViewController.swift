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
                    print(temps)
                    
                    print("private works")
                    self.works = []
                    // this force unwrap is what is used in the
                    // cloud firestore docs
                    for document in querySnapshot!.documents {
                        if(document.data()["public"] as? String == "private" && document.data()["filePath"] as? String != nil)
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

extension WorksPrivateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worksTableView.dequeueReusableCell(withIdentifier: "private_post") as! PrivateTableViewCell

        let drawingref = storageRef.child((works[indexPath.row])["filePath"] as! String)

        //         Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                drawingref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                  if error != nil {
                    print("uh oh")
                    // Uh-oh, an error occurred!
                  } else {
                    let image = UIImage(data: data!)
                    cell.preview.image = image
                  }
                }
        cell.title.text = (works[indexPath.row])["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "WorksDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "workdetail") as! WorkDetailViewController
        vc.modalPresentationStyle = .fullScreen
        vc.work = works[indexPath.row]
        self.present(vc, animated: true)
    }
}
