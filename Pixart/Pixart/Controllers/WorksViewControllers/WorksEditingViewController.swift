//
//  WorksEditViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/21/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import Firebase
import ColorSlider

class WorksEditingViewController: UIViewController {

    let SLIDER_Y_POS = 50 // space from the canvas
    let SLIDER_HIGHT = 15
    let SLIDER_WIDTH = 300
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""
    
    var work_UUID: String = ""
    var work_name: String = ""
    var canvas_size: Int = 8
    var colors: [String : String] = [:]
    var likes : Int = 0
    
    @IBOutlet weak var card_view: UIView!
    @IBOutlet weak var save_view: UIView!
    @IBOutlet weak var save_top: NSLayoutConstraint!
    @IBOutlet weak var artwork_name: UITextField!
    @IBOutlet weak var canvas: GridView!
    @IBOutlet weak var canvas_container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorSlider()
        card_view.addShadow()
        save_view.addShadow()
        artwork_name.text = work_name
        canvas.loadCanvas(size: canvas_size, colors: colors)
        canvas_container.layer.borderWidth = 5
        canvas_container.layer.borderColor = UIColor.black.cgColor
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? WorksDetailViewController {
            dest.work_name = self.work_name
            dest.colors = self.colors
            dest.likes = self.likes
        }
    }
    
    @IBAction func saveEdits(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.save_top.constant = -60
            self.view.layoutIfNeeded()
        })

        let alert = UIAlertController(title: "Are you sure?", message: "If you save the edit, likes of the work will be reset to 0", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Save the edit", style: .default, handler: {alert in
            if self.likes > 0 {
                self.db.collection(self.userID).document(self.work_UUID).updateData(["likes":0])
                self.likes = 0
            }
            self.view.isUserInteractionEnabled = false
            self.savePixelArt()
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
//    @IBAction func saveEditsAs(_ sender: Any) {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.saveAs_top.constant = -60
//            self.view.layoutIfNeeded()
//        })
//        
//        view.isUserInteractionEnabled = false
//        saveNewPixelArt()
//    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        canvas.resetZoom()
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        canvas.drawingColor = color
    }
    
    private func setupColorSlider() {
        let y_pos = 16 + 32 + Int(canvas_container.frame.width) + 20 + SLIDER_Y_POS
        
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect( x: Int((card_view.frame.width)/2) - Int(SLIDER_WIDTH/2), y: y_pos, width: SLIDER_WIDTH, height: SLIDER_HIGHT)
        card_view.addSubview(colorSlider)
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        colorSlider.color = UIColor.black
    }
    
    private func savePixelArt() {
        colors = canvas.exportColors()
        
        self.db.collection(self.userID).document(self.work_UUID).updateData(["colors": colors], completion: {error in
            if error != nil {
                print("error updating data")
                self.unhideSave()
            }
            else{
                self.performSegue(withIdentifier: "work_edit_return", sender: self)
            }
        })
    }
    
//    private func saveNewPixelArt() {
//        let uuid = UUID().uuidString
//        let gridColors: [String:String] = canvas.exportColors()
//        self.view.isUserInteractionEnabled = false
//
//        self.db.collection(self.userID).document(uuid).setData([
//            "documentdata": uuid,
//            "name": self.work_name,
//            "colors": gridColors,
//            "gridSize": self.canvas_size,
//            "public" : 0
//        ]) { err in
//            self.view.isUserInteractionEnabled = true
//
//            if let err = err {
//                print("Error adding document: \(err)")
//                self.unhideSaveAs()
//            } else {
//                print("Document added")
//                self.performSegue(withIdentifier: "canvas_to_works", sender: self)
//            }
//        }
//    }
    
    private func unhideSave() {
        UIView.animate(withDuration: 0.3, animations: {
            self.save_top.constant = -25
            self.view.layoutIfNeeded()
        })
        
        view.isUserInteractionEnabled = true
    }
    
//    private func unhideSaveAs() {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.saveAs_top.constant = -25
//            self.view.layoutIfNeeded()
//        })
//
//        view.isUserInteractionEnabled = true
//    }
}
