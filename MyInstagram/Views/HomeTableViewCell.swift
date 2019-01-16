//
//  HomeTableViewCell.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 01/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit
//import FirebaseDatabase
//import FirebaseAuth
class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var shareImg: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    var homeViewController: HomeViewController?
    
    var post: Post? {
        didSet {
            updateCellView()
        }
    }
    
    var user: UserModel? {
        didSet {
            loadUserInfo()
        }
    }
    
    
    func updateCellView(){
        descLabel.text = post?.description
        if let urlString = post?.photoUrl {
            postImg.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: Config.POST_PLACEHOLDER))
        }
        
        self.updateLikes(post: self.post!)
    }
    
    func updateLikes(post:Post){
        if post.isLiked == nil {
             likeImg.image = UIImage(named: "zan")
        }else{
            let imageName = (post.likes == nil || !post.isLiked! ? "zan" : "zanSelected")
            likeImg.image = UIImage(named: imageName)
        }
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            likeBtn.setTitle("\(count) likes", for: UIControlState.normal)
        } else {
            likeBtn.setTitle("0 like", for: UIControlState.normal)
        }
    }
    
    
    func loadUserInfo(){
        self.nameLable.text = user?.username
        if let avatarUrlStr = user?.avatarUrl {
            self.avatarView.sd_setImage(with: URL(string: avatarUrlStr), placeholderImage: UIImage(named: "user-placeholder"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLable.text = ""
        self.descLabel.text = ""
        
        let tapComment = UITapGestureRecognizer(target: self, action:  #selector(self.commentImgClicked))
        commentImg.addGestureRecognizer(tapComment)
        commentImg.isUserInteractionEnabled = true
        
        let tapLike = UITapGestureRecognizer(target: self, action:  #selector(self.likeImgClicked))
        likeImg.addGestureRecognizer(tapLike)
        likeImg.isUserInteractionEnabled = true
    }
    
    @objc func likeImgClicked(){
        Api.Post.addLikes(withPostId: post!.id!, onSuccess: { post in
            self.updateLikes(post: post)
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
        }){
            (errorMsg) in
            ProgressHUD.showError(errorMsg)
        }
    }
    
    @objc func commentImgClicked(){
        print("user tapped on the comment icon")
        if let id = post?.id {
            homeViewController?.performSegue(withIdentifier: "commentSegue", sender: id)
        }
    }
    
    
    @IBAction func likeView(_ sender: Any) {
        
        if let id = post?.id {
            homeViewController?.performSegue(withIdentifier: "likeSegue", sender: id)
        }
       
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarView.image = UIImage(named:"user-placeholder")
    }
    

}// class close











