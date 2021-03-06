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
    var queue = DispatchQueue(label: "")
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var options: UISegmentedControl!
    @IBOutlet weak var error_view: UIView!
    @IBOutlet weak var PrivateCollection: UICollectionView!
    @IBOutlet weak var PublicCollection: UICollectionView!
    @IBOutlet weak var privateView: UIView!
    @IBOutlet weak var publishedView: UIView!
    @IBOutlet weak var TrashedTableView: UITableView!
    @IBOutlet weak var publishedView_left: NSLayoutConstraint!
    @IBOutlet weak var publishedView_right: NSLayoutConstraint!
    @IBOutlet weak var privateView_left: NSLayoutConstraint!
    @IBOutlet weak var privateView_right: NSLayoutConstraint!
    @IBOutlet weak var trashedView_left: NSLayoutConstraint!
    @IBOutlet weak var trashedView_right: NSLayoutConstraint!
    @IBOutlet weak var newArtButton_right: NSLayoutConstraint!
    @IBOutlet weak var trashAllButton: UIButton!
    @IBOutlet weak var trashAllButton_right: NSLayoutConstraint!
    
    var backfromdetail = false
    var movetotrash = false
    var restoretrash = false
    var removetrash = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        publishedView_left.constant = 467
        publishedView_right.constant = -433
        trashedView_left.constant = 467
        trashedView_right.constant = -433
        trashAllButton_right.constant = 70
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
            dest.likes = work["likes"] as? Int ?? 0
        }
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            privateView.isHidden = false
            UIView.animate(withDuration: 0.3, animations:{
                self.privateView_left.constant = 17
                self.privateView_right.constant = 17
                self.publishedView_left.constant = 467
                self.publishedView_right.constant = -433
                self.trashedView_left.constant = 467
                self.trashedView_right.constant = -433
                self.newArtButton_right.constant = -4
                self.trashAllButton_right.constant = 70
                self.view.layoutIfNeeded()
            }, completion: { finished in
                if finished {
                    self.publishedView.isHidden = true
                    self.TrashedTableView.isHidden = true
                }
            })
            break
        case 1:
            self.publishedView.isHidden = false
            UIView.animate(withDuration: 0.3, animations:{
                self.privateView_left.constant = -433
                self.privateView_right.constant = 467
                self.publishedView_left.constant = 17
                self.publishedView_right.constant = 17
                self.trashedView_left.constant = 467
                self.trashedView_right.constant = -433
                self.newArtButton_right.constant = -4
                self.trashAllButton_right.constant = 70
                self.view.layoutIfNeeded()
            }, completion: { finished in
                if finished {
                    self.privateView.isHidden = true
                    self.TrashedTableView.isHidden = true
                }
            })
            break
        case 2:
            self.TrashedTableView.isHidden = false
            UIView.animate(withDuration: 0.3, animations:{
                self.privateView_left.constant = -433
                self.privateView_right.constant = 467
                self.publishedView_left.constant = -433
                self.publishedView_right.constant = 467
                self.trashedView_left.constant = 17
                self.trashedView_right.constant = 17
                self.newArtButton_right.constant = 70
                self.trashAllButton_right.constant = -5
                self.view.layoutIfNeeded()
            }, completion: { finished in
                if finished {
                    self.privateView.isHidden = true
                    self.publishedView.isHidden = true
                }
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
    
    @IBAction func trashAll(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to remove the trashed artworks?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            let alert = UIAlertController(title: "Are You Sure?", message: "You won't be able to restore them. Do you really want to remove them permanently?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let removeAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                for work in self.trashedWorks {
                    let work_UUID = work["documentdata"] as? String ?? ""
                    self.db.collection(self.userID).document(work_UUID).delete(completion: { error in
                        if error != nil {
                            print("error deleting")
                        } else {
                            self.removetrash = true
                            self.fetch()
                        }
                    })
                }
            })
            
            alert.addAction(cancelAction)
            alert.addAction(removeAction)
            self.present(alert, animated: true, completion: nil)
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func fetch() {
        self.privateWorks = []
        self.publicWorks = []
        self.trashedWorks = []
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
            self.spinner.startAnimating()
            self.view.isUserInteractionEnabled = false
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
                    
                    if self.trashedWorks.count > 0 {
                        self.trashAllButton.tintColor = UIColor.red
                        self.trashAllButton.isEnabled = true
                    } else {
                        self.trashAllButton.tintColor = UIColor.black
                        self.trashAllButton.isEnabled = false
                    }
                    
                    if self.backfromdetail {   //come back from workdetail view
                        if self.movetotrash {
                            //deleted a work
                            self.TrashedTableView.reloadData()
                            self.movetotrash = false
                        }
                        self.PublicCollection.reloadData()
                        self.PrivateCollection.reloadData()
                        self.backfromdetail = false
                    } else if self.restoretrash {
                        //restored a trash
                        self.TrashedTableView.reloadData()
                        self.PrivateCollection.reloadData()
                        self.restoretrash = false
                    } else if self.removetrash {
                        //removed a trash
                        self.TrashedTableView.reloadData()
                        self.removetrash = false
                    } else {
                        //first time load(come from other views)
                        self.PublicCollection.reloadData()
                        self.PrivateCollection.reloadData()
                        self.TrashedTableView.reloadData()
                    }
                    self.spinner.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    // MARK: Unwind
    @IBAction func unwindToWorks(_ unwindSegue: UIStoryboardSegue) {
        backfromdetail = true
        movetotrash = true
        fetch()
    }
}

extension WorksViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("will dismissed")
        backfromdetail = true
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
            let canvas_width = floor((CGFloat(Application.device_width) - 17 - 17 - 2 - 2 - CELL_PADDING - CELL_PADDING) / 2)
            cell.width.constant = canvas_width
            cell.canvas.makeCells(size: canvasSize, data: colors, canvasWidth: canvas_width)
            return cell
        }
        if collectionView == PrivateCollection {
            let cell = PrivateCollection.dequeueReusableCell(withReuseIdentifier: "private_post", for: indexPath) as! PrivateCollectionViewCell
            let canvasSize = privateWorks[indexPath.row]["gridSize"] as! Int
            let colors : [String:String] = privateWorks[indexPath.row]["colors"] as! [String:String]
            let canvas_width = floor((CGFloat(Application.device_width) - 17 - 17 - 2 - 2 - CELL_PADDING - CELL_PADDING) / 2)
            cell.width.constant = canvas_width
            cell.canvas.makeCells(size: canvasSize, data: colors, canvasWidth: canvas_width)
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
        cell.preview.makeCells(size: gridSize, data: colors, canvasWidth: 100 - 12 - 12)
        cell.title.text = (trashedWorks[indexPath.row])["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        let alert = UIAlertController(title: "Actions:", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let restoreAction = UIAlertAction(title: "Restore", style: .default, handler: restore_handle)
        let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: delete_handle)
        alert.addAction(cancelAction)
        alert.addAction(restoreAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func restore_handle(alert: UIAlertAction) {
        let work_UUID = trashedWorks[self.index]["documentdata"] as? String ?? ""
        self.db.collection(self.userID).document(work_UUID).updateData(["public" : 0], completion: {error in
            if error != nil {
                print("error updating data")
            } else {
                self.restoretrash = true
                self.fetch()
            }
        })
    }
    
    func delete_handle(alert: UIAlertAction) {
        let alert = UIAlertController(title: "Are You Sure?", message: "You won't be able to restore this work. Do you really want to remove it permanently?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let removeAction = UIAlertAction(title: "Yes", style: .destructive, handler: {alert in
            let work_UUID = self.trashedWorks[self.index]["documentdata"] as? String ?? ""
            self.db.collection(self.userID).document(work_UUID).delete(completion: {error in
                if error != nil {
                    print("error deleting")
                } else {
                    self.removetrash = true
                    self.fetch()
                }
            })
        })
        
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        self.present(alert, animated: true, completion: nil)
    }
}
