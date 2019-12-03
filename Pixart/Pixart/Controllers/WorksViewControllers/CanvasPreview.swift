//
//  Canvas_display.swift
//  Pixart
//
//  Created by Hin Chan on 11/21/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit


class CanvasPreview: UIView {
    
    public func makeCells(size: Int, data: [String:String]){
        for v in self.subviews
        {
            v.removeFromSuperview()
        }
        let cellWidth = self.frame.width / CGFloat(size)
        for j in 0...size - 1 {
            for i in 0...size - 1 {
                let cellView = UIView()
                cellView.backgroundColor = UIColor.init(hexString: data["\(i)|\(j)"]!)
                cellView.frame = CGRect(x: CGFloat(i) * cellWidth, y: CGFloat(j) * cellWidth, width: cellWidth, height: cellWidth)
                self.addSubview(cellView)
            }
        }
    }
    
    public func exportToImg() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        
        return image
    }
}
