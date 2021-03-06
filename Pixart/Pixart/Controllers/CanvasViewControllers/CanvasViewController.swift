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
    
    @IBOutlet weak var card_view: UIView!
    @IBOutlet weak var card_view_centerX: NSLayoutConstraint!
    @IBOutlet weak var save_view: UIView!
    @IBOutlet weak var save_view_top: NSLayoutConstraint!
    @IBOutlet weak var save_view_centerX: NSLayoutConstraint!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var canvasContainer: UIView!
    @IBOutlet weak var card_view_left: NSLayoutConstraint!
    @IBOutlet weak var card_view_right: NSLayoutConstraint!
    //    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
//        setupSideMenu()
        setupColorSlider()
//        card_view_width.constant = CGFloat(view.frame.width) - 17 - 17
        card_view.addShadow()
        card_view_left.constant = 448
        card_view_right.constant = -432
        save_view_centerX.constant = 416
        save_view.addShadow()
        canvas_size = LocalStorage.fetchCanvasSize()
        gridView.makeCells(size: canvas_size)
        canvasContainer.layer.borderWidth = 5
        canvasContainer.layer.borderColor = UIColor.black.cgColor
        Application.current_VC = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user?.uid ?? ""
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: Application.transition_speed, animations: {
            self.card_view_left.constant = 8
            self.card_view_right.constant = 8
            self.save_view_centerX.constant = 0
            self.view.layoutIfNeeded()
        })
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
    
    @IBAction func save(_ sender: Any) {
        self.performSegue(withIdentifier: "naming_prompt", sender: self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.save_view_top.constant = -60
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        gridView.drawingColor = color
    }
    
    private func setupSideMenu() {
        if Application.sidemenu_initialized == false {
            Application.sidemenu_initialized = true
            let storyboard = UIStoryboard(name: "SideMenu", bundle: nil)
            SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
            SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        }
    }
    
    private func savePixelArt() {
        let uuid = UUID().uuidString
        let gridColors: [String:String] = gridView.exportColors()
        let alias = LocalStorage.fetchAlias()
        self.view.isUserInteractionEnabled = false
        
        self.db.collection(self.userID).document(uuid).setData([
            "documentdata": uuid,
            "name": self.work_name,
            "author": alias.isEmpty ? "Anonymous": alias,
            "date": "",
            "colors": gridColors,
            "gridSize": self.canvas_size,
            "public" : 0,
            "likes" : 0
        ]) { err in
            self.view.isUserInteractionEnabled = true
            
            if let err = err {
                print("Error adding document: \(err)")
                self.unhideSave()
            } else {
                print("Document added")
                self.performSegue(withIdentifier: "canvas_to_works", sender: self)
            }
        }
    }
    
    private func setupColorSlider() {
        let card_view_width = Application.device_width - 8 - 8
        let y_pos = card_view_width + 45
        
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect( x: Int(card_view_width/2) - Int(SLIDER_WIDTH/2), y: y_pos, width: SLIDER_WIDTH, height: SLIDER_HIGHT)
        card_view.addSubview(colorSlider)
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        colorSlider.color = UIColor.black
    }
    
    private func unhideSave() {
        UIView.animate(withDuration: 0.3, animations: {
            self.save_view_top.constant = -25
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: UNWIND
    @IBAction func unwindToCanvas(_ unwindSegue: UIStoryboardSegue) {
        gridView.resetZoom()
        gridView.makeCells(size: canvas_size, color: Application.canvas_backgroundColor)
    }
    
    @IBAction func unwindToCanvasAndSave(_ unwindSegue: UIStoryboardSegue) {
        savePixelArt()
    }
    
    @IBAction func unwindToCanvasFromDismiss(_ unwindSegue: UIStoryboardSegue) {
        unhideSave()
    }
}
