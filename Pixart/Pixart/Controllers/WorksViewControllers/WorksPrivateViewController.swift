//
//  WorksPrivateViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/14/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class WorksPrivateViewController: UIViewController { // Works saved on local device

    @IBOutlet weak var worksTableView: UITableView!
    var works: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worksTableView.dataSource = self
        worksTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
}

extension WorksPrivateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worksTableView.dequeueReusableCell(withIdentifier: "private_post") as! PrivateTableViewCell

        cell.preview.image = UIImage(named: "cat.jpg")
        cell.title.text = "cat"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
