//
//  CommentTableViewCell.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 12/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var commentTxt: UILabel!
    @IBOutlet weak var usernameLabelTxt: UILabel!
    
    
    var comment: Comment? {
        didSet {
            updateCellView()
        }
    }
    
    var user: UserModel? {
        didSet {
            loadUserInfo()
        }
    }
    
//    update each cell view
    func updateCellView(){
        commentTxt.text = comment?.comment  // set comment
        //loadUserInfo()                     // load user info
     }
    
    
    func loadUserInfo(){
        usernameLabelTxt.text = user?.username
        if let avatarImgStr = user?.avatarUrl {
            let avatarImgUrl = URL(string: avatarImgStr)
            avatarImg.sd_setImage(with: avatarImgUrl, placeholderImage:UIImage(named:"user-placeholder"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentTxt.text = ""
        usernameLabelTxt.text = ""
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImg.image = UIImage(named: "user-placeholder")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
