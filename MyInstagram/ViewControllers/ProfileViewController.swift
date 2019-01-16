//
//  ProfileViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 17/09/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit
class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var user: UserModel!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.dataSource = self
        collectionView.delegate = self
        getUserInfo()
        getUserPosts()
    }

    func getUserInfo(){
        Api.User.getCurrentUser(completion: {
            (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        })
    }
    
    func getUserPosts(){
        guard let currentUser = Api.User.CURRENT_USER else{
            return
        }
        
        Api.UserPosts.DB_UserPosts.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.Post.getPost(withId: snapshot.key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        })
    }
}//class close

extension ProfileViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let profileHeaderViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCollectionReusableView
        if let user = self.user {
            profileHeaderViewCell.user = user
        }
        return profileHeaderViewCell
    }
    
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/4-1, height: collectionView.frame.size.height/4-1)
    }
}


