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
    
    let CELL_PADDING: CGFloat = 5 // MARK: NOTE: canvas preview width x 2 + padding <= view width for there to be two columns. Make sure any size changes won't violate the above.
    
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var privateWorks: [[String: Any]] = []
    var publicWorks: [[String: Any]] = []
    var trashedWorks: [[String: Any]] = []
    var userID = ""
    var index: Int = 0
    
    @IBOutlet weak var options: UISegmentedControl!
    @IBOutlet weak var error_view: UIView!
    @IBOutlet weak var PrivateCollection: UICollectionView!
    @IBOutlet weak var PublicCollection: UICollectionView!
    @IBOutlet weak var TrashedTableView: UITableView!
    @IBOutlet weak var publishedView_X_constraint: NSLayoutConstraint!
    @IBOutlet weak var privateView_X_constraint: NSLayoutConstraint!
    @IBOutlet weak var trashedView_X_constraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        publishedView_X_constraint.constant = 416
        trashedView_X_constraint.constant = 416
        Application.current_VC = self
        PublicCollection.dataSource = self
        PublicCollection.delegate = self
        PrivateCollection.dataSource = self
        PrivateCollection.delegate = self
        TrashedTableView.dataSource = self
        TrashedTableView.delegate = self
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
            UIView.animate(withDuration: 0.3, animations:{
                self.privateView_X_constraint.constant = 0
                self.publishedView_X_constraint.constant = 416
                self.trashedView_X_constraint.constant = 416
                self.view.layoutIfNeeded()
            })
            break
        case 1:
            UIView.animate(withDuration: 0.3, animations:{
                self.privateView_X_constraint.constant = -416
                self.publishedView_X_constraint.constant = 0
                self.trashedView_X_constraint.constant = 416
                self.view.layoutIfNeeded()
            })
            break
        case 2:
            UIView.animate(withDuration: 0.3, animations:{
                self.privateView_X_constraint.constant = -416
                self.publishedView_X_constraint.constant = -416
                self.trashedView_X_constraint.constant = 0
                self.view.layoutIfNeeded()
            })
            break
        default:
            print("Unknown segment index.")
        }
    }
    
    @IBAction func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizer.Direction.right && options.selectedSegmentIndex > 0 {
            options.selectedSegmentIndex -= 1
            switchViews(options)
        } else if sender.direction == UISwipeGestureRecognizer.Direction.left && options.selectedSegmentIndex < 2 {
            options.selectedSegmentIndex += 1
            switchViews(options)
        }
        
        return
    }
    
    @IBAction func newPressed(_ sender: Any) {
        performSegue(withIdentifier: "works_to_canvas", sender: self)
    }
    
    private func fetch() {
        self.privateWorks = []
        self.publicWorks = []
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
            self.db.collection(self.userID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.error_view.isHidden = false
                } else {
                    for document in querySnapshot!.documents {
                        if(document.data()["colors"] as? [String:String] != nil) {
                            if (document.data()["public"] as? Int == 0) {
                                self.privateWorks.append(document.data())
                            } else if (document.data()["public"] as? Int == 1) {
                                self.publicWorks.append(document.data())
                            } else if (document.data()["public"] as? Int == -1) {
                                self.trashedWorks.append(document.data())
                            }
                        }
                    }
                    self.PublicCollection.reloadData()
                    self.PrivateCollection.reloadData()
                    self.TrashedTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Unwind
    @IBAction func unwindToWorks(_ unwindSegue: UIStoryboardSegue) {
        fetch()
    }
}

extension WorksViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("will dismissed")
        fetch()
    }
}

// MARK: Collection View
extension WorksViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == PublicCollection {
            return publicWorks.count
        }
        if collectionView == PrivateCollection {
            return privateWorks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == PublicCollection {
            let cell = PublicCollection.dequeueReusableCell(withReuseIdentifier: "published_post", for: indexPath) as! PublicCollectionViewCell
            let canvasSize = publicWorks[indexPath.row]["gridSize"] as! Int
            let colors : [String:String] = publicWorks[indexPath.row]["colors"] as! [String:String]
            cell.canvas.makeCells(size: canvasSize, data: colors)
            return cell
        }
        if collectionView == PrivateCollection {
            let cell = PrivateCollection.dequeueReusableCell(withReuseIdentifier: "private_post", for: indexPath) as! PrivateCollectionViewCell
            let canvasSize = privateWorks[indexPath.row]["gridSize"] as! Int
            let colors : [String:String] = privateWorks[indexPath.row]["colors"] as! [String:String]
            cell.canvas.makeCells(size: canvasSize, data: colors)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        collectionView.deselectItem(at: indexPath, animated: true)
        index = indexPath.row
        if collectionView == PublicCollection {
            performSegue(withIdentifier: "works_detail_published", sender: self)
        }
        if collectionView == PrivateCollection {
            performSegue(withIdentifier: "works_detail_private", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let NumberItemPerRow : CGFloat = 2
        let width = (collectionView.frame.width - (NumberItemPerRow - 1) * CELL_PADDING ) / NumberItemPerRow
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CELL_PADDING
    }
}


// MARK: Table View
extension WorksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trashedWorks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trashed") as! TrashedTableViewCell
        let gridSize = (trashedWorks[indexPath.row])["gridSize"] as! Int
        let colors: [String:String] = (trashedWorks[indexPath.row])["colors"] as! [String:String]
        cell.preview.makeCells(size: gridSize, data: colors)
        cell.title.text = (trashedWorks[indexPath.row])["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
//        index = indexPath.row
//        performSegue(withIdentifier: "works_detail_published", sender: self)
    }
}
