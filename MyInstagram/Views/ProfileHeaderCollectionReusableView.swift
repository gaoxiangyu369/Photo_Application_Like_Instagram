//
//  ProfileHeaderCollectionReusableView.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 13/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var followersNum: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var postsNum: UILabel!
    @IBOutlet weak var usernameLable: UILabel!
    
    var user: UserModel? {
        didSet {
            updateView()
        }
    }
    
    func updateView(){
        let currentUser = Api.User.CURRENT_USER!.uid
        self.usernameLable.text = user!.username
        Api.UserPosts.getPostsNum(withId: currentUser, completion: { (num) in
            self.postsNum.text = String(num)
        })
        Api.Follow.getCount(withId: currentUser) { (num) in
            self.followersNum.text = String(num)
        }
        Api.Follow.getFollowingCount(withId: currentUser) { (num) in
            self.followingNum.text = String(num)
        }
        
        if let avatarUrlStr = user!.avatarUrl {
            let avatarUrl = URL(string: avatarUrlStr)
            self.avatarImg.sd_setImage(with: avatarUrl)
        }
    }
}












