//
//  CanvasViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/7/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import SideMenu
import ColorSlider
import Firebase

class CanvasViewController: UIViewController {
    var root: UIViewController?
    
    let SLIDER_HIGHT = 15
    let SLIDER_WIDTH = 300
    let storage = Storage.storage()
    var storageRef = StorageReference.init()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    
    @IBOutlet weak var drawingName: UITextField!
    @IBOutlet weak var gridView: GridView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = storage.reference()
   
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect( x: Int((view.frame.width)/2) - Int(SLIDER_WIDTH/2), y:  Int(view.frame.height) - 180, width: SLIDER_WIDTH, height: SLIDER_HIGHT)
             view.addSubview(colorSlider)
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // force unwrap justified since handle will never be nil after
        // viewWillAppear called  (can only get to this view with authenticated
        // user)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // This function saves the image to user folder
    // TODO: right now  it just displays it to the view
    // but i will change later
    @IBAction func savePixelArt(_ sender: Any) {
        
        let renderer = UIGraphicsImageRenderer(size: gridView.bounds.size)
        let image = renderer.image { ctx in
            gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        }
//        db.collection(userID).document("drawing").set
        // Data in memory
        let data = image.pngData() ?? Data()

        // Create a reference to the file you want to upload
        let location = userID + "/" + (drawingName.text ?? "NoName")
        let riversRef = storageRef.child(location)

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
            
    
    }
    
    
    
    @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        gridView.drawingColor  = color
    }
    
    
    
  
}
