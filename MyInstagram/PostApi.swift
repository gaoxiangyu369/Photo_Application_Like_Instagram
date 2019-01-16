//
//  PostApi.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 13/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class PostApi{
    var DB_Posts = Database.database().reference().child("posts")
    
    //get all posts
    func observePosts(completion: @escaping (Post)-> Void){
        DB_Posts.observe(.childAdded, with: {
            (snapshot: DataSnapshot) in
            if let postsDict = snapshot.value as? [String:Any]{
                let newPost = Post.formatPost(dict:postsDict,key: snapshot.key)
                completion(newPost)
            }
        })
    }
    
    //get a post by its id
    func getPost(withId userId:String ,completion: @escaping (Post)-> Void){
        DB_Posts.child(userId).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String:Any] {
                let post = Post.formatPost(dict: dict,key: snapshot.key)
                completion(post)
            }
        })
    }
    
    // get a liked user by a userId via a post
    
    
    func getPostLikeCount(withPostId postId: String, completion:@escaping (Int)-> Void ){
        DB_Posts.child(postId).observe(.childChanged, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                completion(value)
            }
        })
    }
    
    
//    func getLikedPeople(withPostId postId:String, completion: @escaping (UserModel) -> Void){
//        DB_Posts.child(postId)
//    }
    
    func addLikes(withPostId postId:String, onSuccess: @escaping (Post) -> Void, onFailure: @escaping (_ errorMsg: String?) -> Void){
        let ref = Api.Post.DB_Posts.child(postId)
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Api.User.CURRENT_USER?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unlike the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to likes
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onFailure(error.localizedDescription)
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.formatPost(dict: dict, key: snapshot!.key)
                onSuccess(post)
            }
        }
    }
    
} //class close
