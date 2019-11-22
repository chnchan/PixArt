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
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var storageRef = StorageReference.init()
    var handle: AuthStateDidChangeListenerHandle?
    var work: [String: Any] = [:]
    var canvas_size: Int = 8
    
    @IBOutlet weak var artwork_name: UITextField!
    @IBOutlet weak var canvas: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorSlider()
        load()
    }
    
    @IBAction func saveEdits(_ sender: Any) {
        savePixelArt()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        canvas.drawingColor = color
    }
    
    private func load() {
        artwork_name.text = work["name"] as? String
        
        canvas_size = work["gridSize"] as! Int
        let colors = work["colors"] as! [String:String]
        canvas.loadCanvas(size: canvas_size, data: colors)
    }
    
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setupColorSlider() {
        let y_pos = safeArea_top + 48 + 45 + Int(view.frame.width) - 10 + SLIDER_Y_POS
        
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect( x: Int((view.frame.width)/2) - Int(SLIDER_WIDTH/2), y: y_pos, width: SLIDER_WIDTH, height: SLIDER_HIGHT)
        view.addSubview(colorSlider)
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        colorSlider.color = UIColor.black
    }
    
    private func savePixelArt() {
        print("updating")
        // MARK: TODO
        dismiss(animated: true, completion: nil)
    }
}
