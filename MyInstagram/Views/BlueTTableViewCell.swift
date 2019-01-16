//
//  BlueTTableViewCell.swift
//  MyInstagram
//
//  Created by Liang Zhang on 19/10/18.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class BlueTTableViewCell: UITableViewCell {

    @IBOutlet weak var postImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
