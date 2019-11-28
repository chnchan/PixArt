//
//  SettingsPopupViewController.swift
//  Pixart
//
//  Created by Hin Chan on 11/17/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit
import ColorSlider

class SettingsPopupViewController: UIViewController {

    let SLIDER_Y_POS = 250
    let SLIDER_HIGHT = 15
    let SLIDER_WIDTH = 300
    var canvas_size: Int = 8
    
    @IBOutlet weak var options: UISegmentedControl!
    @IBOutlet var background: UIView!
    @IBOutlet weak var centerX: NSLayoutConstraint!
    @IBOutlet weak var view_container: UIView!
    @IBOutlet weak var color_indicator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupColorSlider()
        centerX.constant = -416
        background.addShadow(radius: 0.5)
        color_indicator.layer.borderColor = UIColor.black.cgColor
        color_indicator.layer.borderWidth = 0.5
        color_indicator.layer.cornerRadius = 12
        
        if canvas_size == Application.canvas_sizes[0] {
            options.selectedSegmentIndex = 0
        } else if canvas_size == Application.canvas_sizes[1] {
            options.selectedSegmentIndex = 1
        } else if canvas_size == Application.canvas_sizes[2] {
            options.selectedSegmentIndex = 2
        } else if canvas_size == Application.canvas_sizes[3] {
            options.selectedSegmentIndex = 3
        } else {
            print("Unknown canvas size!")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.centerX.constant = 0
            self.background.backgroundColor = UIColor.black.withAlphaComponent(0.30)
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupColorSlider() {
        let y_pos =  48 + 45 + Int(view_container.frame.width) - 10 - SLIDER_Y_POS
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect( x: Int((view_container.frame.width)/2) - Int(SLIDER_WIDTH/2), y: y_pos, width: SLIDER_WIDTH, height: SLIDER_HIGHT)
        view_container.addSubview(colorSlider)
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        colorSlider.color = Application.canvas_backgroundColor
        color_indicator.backgroundColor = Application.canvas_backgroundColor
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        Application.canvas_backgroundColor = slider.color
        color_indicator.backgroundColor = Application.canvas_backgroundColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CanvasViewController {
            dest.canvas_size = Application.canvas_sizes[options.selectedSegmentIndex]
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.centerX.constant = 416
            self.background.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished == true {
                self.dismiss(animated: false, completion: nil)
            }
        })
        
    }
    
    @IBAction func apply(_ sender: Any) {
        LocalStorage.saveCanvasSize(size: Application.canvas_sizes[options.selectedSegmentIndex])
        
        UIView.animate(withDuration: 0.2, animations: {
            self.centerX.constant = 416
            self.background.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished == true {
                self.performSegue(withIdentifier: "unwind_canvas", sender: self)
            }
        })
    }
    
}
