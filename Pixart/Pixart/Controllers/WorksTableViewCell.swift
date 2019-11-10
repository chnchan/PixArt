//
//  WorksTableViewCell.swift
//  Pixart
//
//  Created by Ronald Guerra on 11/9/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//
//  This is the custom cell

import UIKit

class WorksTableViewCell: UITableViewCell {

    
    @IBOutlet weak var pixelArtImage: UIImageView!
    @IBOutlet weak var pixelArtName: UILabel!
    @IBOutlet weak var dislikes: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }

}
