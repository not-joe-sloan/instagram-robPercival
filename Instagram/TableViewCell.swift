//
//  TableViewCell.swift
//  Instagram
//
//  Created by Joe Sloan on 12/7/17.
//  Copyright © 2017 Joe Sloan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var postedImage: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
