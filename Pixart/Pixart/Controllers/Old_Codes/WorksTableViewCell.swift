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
    @IBOutlet weak var sharemessage: UILabel!
    @IBOutlet weak var shareswitch: UISwitch!
    var isShareable: Bool! = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }

    @IBAction func shareswitchtoggled(_ sender: UISwitch) {
        self.isShareable = sender.isOn
        if self.isShareable
        {
            self.sharemessage.text = "Public To Other Users"
        }
        else{
            self.sharemessage.text = "Private To Other Users"
        }
    }
}
