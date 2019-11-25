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

class CanvasViewController: UIViewController, UITextFieldDelegate {
    
    let SLIDER_Y_POS = 50 // space from the canvas
    let SLIDER_HIGHT = 15
    let SLIDER_WIDTH = 300
    
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var userID = ""

    var work_name: String = ""
    var canvas_size: Int = 8
    var BACKGROUND_COLOR: UIColor = UIColor.white
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var canvasContainer: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas_size = LocalStorage.fetchCanvasSize()
        gridView.makeCells(size: canvas_size)
        setupColorSlider()
        
        canvasContainer.layer.borderWidth = 5
        canvasContainer.layer.borderColor = UIColor.black.cgColor
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
        if let dest = segue.destination as? SettingsPopupViewController {
            dest.canvas_size = self.canvas_size
        }
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        gridView.resetZoom()
    }
    
    private func savePixelArt() {
        let uuid = UUID().uuidString
        let gridColors: [String:String] = gridView.exportColors()
        self.view.isUserInteractionEnabled = false
        self.spinner.startAnimating()
        
        self.db.collection(self.userID).document(uuid).setData([
            "documentdata": uuid,
            "name": self.work_name,
            "colors": gridColors,
            "gridSize": self.canvas_size,
            "public" : 0
        ]) { err in
            self.view.isUserInteractionEnabled = true
            self.spinner.stopAnimating()
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
                self.performSegue(withIdentifier: "canvas_to_works", sender: self)
            }
        }
    }

    @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        gridView.drawingColor = color
    }
    
    private func setupColorSlider() {
        let y_pos = safeArea_top + 48 + 45 + Int(view.frame.width) - 10 + SLIDER_Y_POS
        
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect( x: Int((view.frame.width)/2) - Int(SLIDER_WIDTH/2), y: y_pos, width: SLIDER_WIDTH, height: SLIDER_HIGHT)
        view.addSubview(colorSlider)
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        colorSlider.color = UIColor.black
    }
    
    // MARK: UNWIND
    @IBAction func unwindToCanvas(_ unwindSegue: UIStoryboardSegue) {
        gridView.makeCells(size: canvas_size, color: BACKGROUND_COLOR)
    }
    
    @IBAction func unwindToCanvasAndSave(_ unwindSegue: UIStoryboardSegue) {
        savePixelArt()
    }
}
