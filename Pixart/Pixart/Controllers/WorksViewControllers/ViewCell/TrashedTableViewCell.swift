//
//  TrashTableViewCell.swift
//  Pixart
//
//  Created by jizhi on 11/22/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import UIKit

class TrashedTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var preview: CanvasPreview!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
