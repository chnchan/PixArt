//
//  PopularViewController.swift
//  Pixart
//
//  Created by Ronald Guerra on 12/4/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class PopularViewController: UIViewController {

    let CELL_PADDING: CGFloat = 6 // MARK: NOTE: canvas preview width x 2 + padding <= view width for there to be two columns. Make sure any size changes won't violate the above.
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var popularlist: [[String:Any]] = []
    var popularworks : [[String: Any]] = []
    var index : Int = 0
    
    @IBOutlet weak var popularCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        fetchPopulars(num: 30)
        popularCollection.dataSource = self
        popularCollection.delegate = self
        Application.current_VC = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ImageViewController {
            let work = popularworks[index]
            dest.presentationController?.delegate = self
            dest.work_UUID = work["documentdata"] as? String ?? ""
            dest.work_name = work["name"] as? String ?? ""
            dest.canvas_size = work["gridSize"] as! Int
            dest.colors = work["colors"] as! [String:String]
            dest.likes = work["likes"] as? Int ?? 0
            dest.author = work["author"] as! String
            dest.date = work["date"] as! String
        }
    }
    
    
    private func fetchPopulars(num : Int){
        self.popularlist = []
        let query = db.collection("PublishedWorks").order(by: "likes", descending: true).limit(to: num)
        query.getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if(document.data()["userID"] as? String != nil) {
                        self.popularlist.append(document.data())
                    }
                }
                //print(self.popularlist)
                self.getPictures()
            }
        }
    }
    
    private func getPictures() {
        self.popularworks = []
        var count = 0
        
        for works in popularlist {
            let authorID = works["userID"] as! String
            let workID = works["workID"] as! String
            db.collection(authorID).document(workID).getDocument() { (document, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    /*let name = document!["name"] as! String
                    let gridColors = document!["colors"] as! [String:String]
                    let gridSize = document!["gridSize"] as! Int
                    let author = document!["author"] as! String
                    let date = document!["date"] as! String
                    print(name)
                    print(author)
                    print(gridSize)
                    print(date)*/
                    self.popularworks.append(document!.data()!)
                    count += 1
                }
                //print(self.popularworks)
                if (count >= 2) { // when there is only one object, it wont cause a flicker. Won't be an issue when there is more than 1 published art
                    self.popularCollection.reloadData()
                }
              }
          }
      }
}

extension PopularViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popularCollection.dequeueReusableCell(withReuseIdentifier: "popular_post", for: indexPath) as! PopularCollectionViewCell
        let canvasSize = popularworks[indexPath.row]["gridSize"] as! Int
        let colors : [String:String] = popularworks[indexPath.row]["colors"] as! [String:String]
        let canvas_width = floor((CGFloat(Application.device_width) - 17 - 17 - 2 - 2 - CELL_PADDING - CELL_PADDING) / 2)
        cell.width.constant = canvas_width
        cell.canvas.makeCells(size: canvasSize, data: colors, canvasWidth: canvas_width)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        index = indexPath.row
        performSegue(withIdentifier: "popular_detail", sender: self)
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


extension PopularViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        //fetchPopulars(num: 30)
    }
}
