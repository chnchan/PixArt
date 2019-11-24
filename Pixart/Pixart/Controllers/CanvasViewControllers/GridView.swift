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
    
    var canvas_size: Int = 0
    var cells = [String: UIView]()
    var cellWidth: CGFloat = 0
    var drawingColor =  UIColor.red


    override func draw(_ rect: CGRect) {
        self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(gesture:))))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleGesturePan)))
        
        let oneTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGestureTap))
        self.addGestureRecognizer(oneTapGesture)
     }
    

    
    // this function zooms in and out
    @objc func pinchAction(gesture:UIPinchGestureRecognizer) {
   
         if let view = gesture.view {
              switch gesture.state {
              case .changed:
                  let pinchCenter = CGPoint(x: gesture.location(in: view).x - view.bounds.midX,
                                            y: gesture.location(in: view).y - view.bounds.midY)
                  let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                                                  .scaledBy(x: gesture.scale, y: gesture.scale)
                                                  .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
                  view.transform = transform
                  gesture.scale = 1
              default:
                  return
              }
          }
    }
    
    
    @objc func handleGesturePan(gesture: Any?) {
        if let panGesture = gesture as? UIPanGestureRecognizer {
            let location = panGesture.location(in: self)
            let i = Int(location.x / cellWidth)
            let j = Int(location.y / cellWidth)
            let cellView = cells["\(i)|\(j)"]
            cellView?.backgroundColor = drawingColor
        }
    }
    @objc func handleGestureTap(gesture: Any?) {
        if let tapGesture = gesture as? UITapGestureRecognizer {
            let location = tapGesture.location(in: self)
            let i = Int(location.x / cellWidth)
            let j = Int(location.y / cellWidth)
            let cellView = cells["\(i)|\(j)"]
            cellView?.backgroundColor = drawingColor
        }
    }

    public func resetZoom() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
    public func makeCells(size: Int, color: UIColor = UIColor.white){
        canvas_size = size
        cellWidth = self.frame.width / CGFloat(canvas_size)
        
        for j in 0...canvas_size - 1 {
            for i in 0...canvas_size - 1 {
                let cellView = UIView()
                
                cellView.backgroundColor = color
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

