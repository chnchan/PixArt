//
//  GridView.swift
//  Pixart
//
//  Created by Ronald Guerra on 11/9/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class GridView: UIView {

    let BORDER_WIDTH: CGFloat = 0.5
    let BORDER_COLOR = UIColor.black.cgColor
    let BACKGROUND_COLOR = UIColor.white
    
    var canvas_size: Int = 0
    var cells = [String: UIView]()
    var cellWidth: CGFloat = 0
    var drawingColor =  UIColor.red
    var previousScale: CGFloat = 1.0

    override func draw(_ rect: CGRect) {
        self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:))))
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
            let i = Int(location.x / cellWidth)
            let j = Int(location.y / cellWidth)
            let cellView = cells["\(i)|\(j)"]
            cellView?.backgroundColor = drawingColor
        }
        
        if let tapGesture = gesture as? UITapGestureRecognizer {
            let location = tapGesture.location(in: self)
            let i = Int(location.x / cellWidth)
            let j = Int(location.y / cellWidth)
            let cellView = cells["\(i)|\(j)"]
            cellView?.backgroundColor = drawingColor
        }
    }

    public func makeCells(){
        canvas_size = LocalStorage.fetchCanvasSize()
        cellWidth = self.frame.width / CGFloat(canvas_size)
        
        for j in 0...canvas_size - 1 {
            for i in 0...canvas_size - 1 {
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
    
    public func loadCanvas(size: Int, colors: [String:String]){
        canvas_size = size
        cellWidth = self.frame.width / CGFloat(canvas_size)
        
        for j in 0...canvas_size - 1 {
            for i in 0...canvas_size - 1 {
                let cellView = UIView()
                cellView.backgroundColor = UIColor.init(hexString: colors["\(i)|\(j)"]!)
                cellView.layer.borderWidth = BORDER_WIDTH
                cellView.layer.borderColor = BORDER_COLOR
                cellView.frame = CGRect(x: CGFloat(i) * cellWidth, y: CGFloat(j) * cellWidth, width: cellWidth, height: cellWidth)
                self.addSubview(cellView)
                cells["\(i)|\(j)"] = cellView
            }
        }
    }
    
    public func exportColors() -> [String: String] {
        var gridColors: [String:String] = [:]
        
        for j in 0...canvas_size - 1 {
            for i in 0...canvas_size - 1 {
                gridColors["\(i)|\(j)"] = cells["\(i)|\(j)"]?.backgroundColor!.htmlRGBA
            }
        }
        
        return gridColors
    }
}
