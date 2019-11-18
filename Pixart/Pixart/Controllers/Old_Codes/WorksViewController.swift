//
//  WorksViewController.swift
//  Pixart
//
//  Created by Ronald Guerra on 11/9/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class WorksViewController: UIViewController {

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
                    print("hi")
                    // this force unwrap is what is used in the
                    // cloud firestore docs
                    for document in querySnapshot!.documents {
                        self.works.append(document.data())
                    }
                }
                
                print(self.works)
                self.worksTableView.reloadData()
            }
           

        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // force unwrap justified since handle will never be nil after
        // viewWillAppear called  (can only get to this view with authenticated
        // user)
        Auth.auth().removeStateDidChangeListener(handle!)
    }

}
extension WorksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worksTableView.dequeueReusableCell(withIdentifier: "published_post") as! WorksTableViewCell
        // fix force unwrap
        let drawingref = storageRef.child((works[indexPath.row])["filePath"] as! String)

//         Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        drawingref.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if error != nil {
            print("uh oh")
            // Uh-oh, an error occurred!
          } else {
            let image = UIImage(data: data!)
            cell.pixelArtImage.image = image
          }
        }
        
        cell.pixelArtName.text = (works[indexPath.row])["name"] as? String
        cell.dislikes.text = "10"
        cell.likes.text = "10"
        return cell
    }
    
}
