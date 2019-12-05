//
//  PopularDetailViewController.swift
//  Pixart
//
//  Created by jizhi on 12/5/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase

class PopularDetailViewController: UIViewController {

    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    var work_UUID: String = ""
    var work_name: String = ""
    var canvas_size : Int = 8
    var colors: [String : String] = [:]
    var likes : Int = 0
    var author: String = ""
    var date : String = ""
    
    @IBOutlet weak var preview: CanvasPreview!
    @IBOutlet weak var workname: UILabel!
    @IBOutlet weak var authorname: UILabel!
    @IBOutlet weak var publishdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preview.makeCells(size: self.canvas_size, data: self.colors)
        self.workname.text = self.work_name
        self.authorname.text = self.author
        self.publishdate.text = "Published on " + self.date
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}