//
//  Canvas_display.swift
//  Pixart
//
//  Created by Hin Chan on 11/21/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class CanvasPreview: UIView {
    
    func makeCells(size: Int, cells: [String:UIView]){
        let cellWidth: CGFloat = self.frame.width / CGFloat(size)
        for j in 0...size - 1 {
            for i in 0...size - 1 {
                let cellView = cells["\(i)|\(j)"]
                cellView?.frame = CGRect(x: CGFloat(i) * cellWidth, y: CGFloat(j) * cellWidth, width: cellWidth, height: cellWidth)
                self.addSubview(cellView!)
            }
        }
    }
}
