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

class CanvasViewController: UIViewController {
    var root: UIViewController?
    
    let SLIDER_HIGHT = 15
    let SLIDER_WIDTH = 300
    
    override func viewDidLoad() {
     super.viewDidLoad()
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect( x: Int((view.frame.width)/2) - Int(SLIDER_WIDTH/2), y:  Int(view.frame.height) - 180, width: SLIDER_WIDTH, height: SLIDER_HIGHT)
             view.addSubview(colorSlider)
    }
    
  
}
