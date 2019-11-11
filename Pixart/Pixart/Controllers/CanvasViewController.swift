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
    
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var pixelArtImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect( x: Int((view.frame.width)/2) - Int(SLIDER_WIDTH/2), y:  Int(view.frame.height) - 180, width: SLIDER_WIDTH, height: SLIDER_HIGHT)
             view.addSubview(colorSlider)
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
    }
    
    // This function saves the image to user folder
    // TODO: right now  it just displays it to the view
    // but i will change later
    @IBAction func savePixelArt(_ sender: Any) {
        
        let renderer = UIGraphicsImageRenderer(size: gridView.bounds.size)
        let image = renderer.image { ctx in
            gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        }
        
        pixelArtImage.image = image
    
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        gridView.drawingColor  = color
    }
    
    
    
  
}
