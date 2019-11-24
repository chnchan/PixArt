//
//  WorksTrashViewController.swift
//  Pixart
//
//  Created by jizhi on 11/22/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class WorksTrashViewController: UIViewController {

    @IBOutlet weak var worksTableView: UITableView!
    
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    var works: [[String: Any]] = []
    var chosenindex : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        worksTableView.dataSource = self
        worksTableView.delegate = self
        // Do any additional setup after loading the view.
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
            let work = works[chosenindex]
            dest.presentationController?.delegate = self
            dest.work_UUID = work["documentdata"] as? String ?? ""
            dest.work_name = work["name"] as? String ?? ""
            dest.published = work["public"] as! Int
            dest.canvas_size = work["gridSize"] as! Int
            dest.colors = work["colors"] as! [String:String]
        }
    }
    
    private func fetch() {
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
            self.db.collection(self.userID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.works = []
                    // this force unwrap is what is used in the
                    // cloud firestore docs
                    for document in querySnapshot!.documents {
                        if(document.data()["public"] as? Int == -1 && document.data()["colors"] as? [String:String] != nil)
                        {
                            self.works.append(document.data())
                        }
                    }
                }
                self.worksTableView.reloadData()
            }
        }
    }
    
    @IBAction func DeleteAll(_ sender: UIButton) {
        for work in works {
            let documentdata = work["documentdata"] as? String ?? ""
            self.db.collection(self.userID).document(documentdata).delete(completion: {error in
                if error != nil {
                    print("error deleting")
                } else {
                    self.fetch()
                }
            })
        }
    }
    
}
extension WorksTrashViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        fetch()
    }
}

extension WorksTrashViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worksTableView.dequeueReusableCell(withIdentifier: "trash_post") as! PrivateTableViewCell
        let gridSize = (works[indexPath.row])["gridSize"] as! Int
        let colors: [String:String] = (works[indexPath.row])["colors"] as! [String:String]
        cell.preview.makeCells(size: gridSize, data: colors)
        cell.title.text = (works[indexPath.row])["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        self.chosenindex = indexPath.row
        performSegue(withIdentifier: "trash_detail", sender: self)
        
    }
}
