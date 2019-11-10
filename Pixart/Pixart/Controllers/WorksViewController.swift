//
//  WorksViewController.swift
//  Pixart
//
//  Created by Ronald Guerra on 11/9/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class WorksViewController: UIViewController {

    @IBOutlet weak var worksTableView: UITableView!
    var works = ["cat", "wolf"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        worksTableView.dataSource = self
        worksTableView.delegate = self
       // worksTableView.reloadData()
        
    }
    

}
extension WorksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worksTableView.dequeueReusableCell(withIdentifier: "published_post") as! WorksTableViewCell
        cell.pixelArtImage.image = UIImage (named: (works[indexPath.row] + ".jpg"))
        cell.pixelArtName.text = works[indexPath.row]
        cell.dislikes.text = "10"
        cell.likes.text = "10"
        return cell
    }
    
}
