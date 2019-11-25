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
    
    @IBOutlet weak var artwork_name: UITextField!
    @IBOutlet weak var canvas: GridView!
    @IBOutlet weak var canvas_container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorSlider()
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
        }
    }
    
    @IBAction func saveEdits(_ sender: Any) {
        savePixelArt()
    }
    
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
        let y_pos = safeArea_top + 48 + 45 + Int(view.frame.width) - 10 + SLIDER_Y_POS
        
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect( x: Int((view.frame.width)/2) - Int(SLIDER_WIDTH/2), y: y_pos, width: SLIDER_WIDTH, height: SLIDER_HIGHT)
        view.addSubview(colorSlider)
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        colorSlider.color = UIColor.black
    }
    
    private func savePixelArt() {
        colors = canvas.exportColors()
        
        self.db.collection(self.userID).document(self.work_UUID).updateData(["colors": colors], completion: {error in
            if error != nil
            {
                print("error updating data")
            }
            else{
                self.performSegue(withIdentifier: "work_edit_return", sender: self)
            }
        })
    }
}
