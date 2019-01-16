//
//  DiscoverTableViewCell.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 15/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followingBtn: UIButton!
    
    var user: UserModel? {
        didSet {
            updateCellView()
        }
    }
    
    func updateCellView(){
        usernameLabel.text = user?.username
        if let urlString = user?.avatarUrl {
            avatarImg.sd_setImage(with: URL(string: urlString), completed: nil)
        }
        
        if user!.isFollowing! == false {
             setFollowButton()
        }else{
             setUnfollowButton()
        }
    }
    
    func setFollowButton(){
        followingBtn.setTitle("Follow", for: UIControlState.normal)
        followingBtn.addTarget(self, action: #selector(self.follow), for: UIControlEvents.touchUpInside)
    }
    
    func setUnfollowButton(){
        followingBtn.setTitle("Unfollow", for: UIControlState.normal)
        followingBtn.addTarget(self, action: #selector(self.unfollow), for: UIControlEvents.touchUpInside)
    }
    
    @objc func follow(){
        if user!.isFollowing == false{
            print("follow tapped!")
            Api.Follow.follow(withCheckedUserId: user!.id!)
            setUnfollowButton()
            user!.isFollowing! = true
            print("\(user!.username!) is set to \(user?.isFollowing!)" )
        }
    }
    
    @objc func unfollow(){
        if user!.isFollowing!{
            print("unfollow tapped!")
            Api.Follow.unfollow(withCheckedUserId:user!.id!)
            setFollowButton()
            user!.isFollowing! = false
            print("\(user!.username!) is set to \(user?.isFollowing!)" )
        }
    }
    

    
    @IBAction func FollowSomeone(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
   

}
