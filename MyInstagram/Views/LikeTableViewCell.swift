//
//  LikeTableViewCell.swift
//  MyInstagram
//
//  Created by Liang Zhang on 19/10/18.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showCell(avatar: String, username: String, activityType: String, imgURL: String) {
        self.avatarImg.sd_setImage(with: URL(string: avatar))
        self.postImg.sd_setImage(with: URL(string: imgURL))
        self.contentLabel.text = username + activityType
    }
}
