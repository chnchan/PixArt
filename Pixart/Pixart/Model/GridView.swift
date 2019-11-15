//
//  GridView.swift
//  Pixart
//
//  Created by Ronald Guerra on 11/9/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    let CELLS_PER_ROW = 15
    let CELLS_PER_COLUMN = 25
    let BORDER_WIDTH: CGFloat = 0.5
    let BORDER_COLOR = UIColor.black.cgColor
    let BACKGROUND_COLOR = UIColor.white
    

    var drawingColor =  UIColor.red
    var cellWidth: CGFloat = 0
    var cells = [String: UIView]()
    var previousScale:CGFloat = 1.0
    

    override func draw(_ rect: CGRect) {
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
             self.addGestureRecognizer(gesture)
        
        
        self.layer.borderColor = UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 3.0/255.0, alpha: 1).cgColor
        self.layer.borderWidth = 3.0
        
         // Calculate cell width based on the width of the view
        cellWidth = self.frame.width / CGFloat(CELLS_PER_ROW)
        
        makeCells()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleGesture)))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture)))
     }
    
    @objc func pinchAction(sender:UIPinchGestureRecognizer) {
        let scale:CGFloat = previousScale * sender.scale
        self.transform = CGAffineTransform(scaleX: scale, y: scale);

        previousScale = sender.scale
      
    }
    
    @objc func handleGesture(gesture: Any?) {
        if let panGesture = gesture as? UIPanGestureRecognizer {
            let location = panGesture.location(in: self)
            print(location)
            
            let cellWidth = self.frame.width / CGFloat(CELLS_PER_ROW)
            print (self.frame.width)
            
            let i = Int(location.x / cellWidth)
            let j = Int(location.y / cellWidth)
            let cellView = cells["\(i)|\(j)"]
            cellView?.backgroundColor = drawingColor
        }
        
        if let tapGesture = gesture as? UITapGestureRecognizer {
            let location = tapGesture.location(in: self)
            let cellWidth = self.frame.width / CGFloat(CELLS_PER_ROW)
            let i = Int(location.x / cellWidth)
            let j = Int(location.y / cellWidth)
            let cellView = cells["\(i)|\(j)"]
            cellView?.backgroundColor = drawingColor
        }
    }
    

    // This function makes a cell which is a view
    func makeCells(){
        
        //let cellsPerRow:Int = Int(self.frame.height / CGFloat(CELLS_PER_ROW))
        
        for j in 0...CELLS_PER_COLUMN {
            for i in 0...CELLS_PER_ROW - 1{
                let cellView = UIView()
                
                cellView.backgroundColor = BACKGROUND_COLOR
                cellView.layer.borderWidth = BORDER_WIDTH
                cellView.layer.borderColor = BORDER_COLOR
                cellView.frame = CGRect(x: CGFloat(i) * cellWidth, y: CGFloat(j) * cellWidth, width: cellWidth, height: cellWidth)

                self.addSubview(cellView)
               
                cells["\(i)|\(j)"] = cellView
            }
        }
    }
    

}
