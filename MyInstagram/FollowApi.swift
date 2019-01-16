//
//  FollowApi.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 16/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi{
    
    var DB_Followers = Database.database().reference().child("followers")
    var DB_Following = Database.database().reference().child("following")
    var users: [UserModel] = []
    var followers: [Int] = []
    
    // get following
    func getFollowing(completion: @escaping (UserModel) -> Void){
        let id = Api.User.CURRENT_USER?.uid
        DB_Following.child(id!).observe(.childAdded, with: {
            (snapshot)  in
            let userId = snapshot.key
            Api.User.getUser(withId: userId, completion: {
                user in
                completion(user)
            })
        })
    }
    
    

    //get a specific user's followers amount
    func getCount(withId id:String,completion: @escaping (Int) -> Void){
        DB_Followers.child(id).observe(DataEventType.value, with: { (snapshot) in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }

    func getFollowingCount(withId id:String,completion: @escaping (Int) -> Void){
        DB_Following.child(id).observe(DataEventType.value, with: { (snapshot) in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    
    //get followers
    func getFollowers(completion: @escaping (UserModel) -> Void){
        let id = Api.User.CURRENT_USER?.uid
        DB_Followers.child(id!).observe(.childAdded, with: {
            (snapshot)  in
            let userId = snapshot.key
            Api.User.getUser(withId: userId, completion: {
                user in
                completion(user)
            })
        })
    }
    
    
    
    func follow(withCheckedUserId id: String){
        Api.UserPosts.DB_UserPosts.child(id).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dict  = snapshot.value as? [String:Any]{
                for key in dict.keys{
                    Database.database().reference().child("postsFeed").child(Api.User.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        })
        // add currrent user to the followers to the checked user
        DB_Followers.child(id).child(Api.User.CURRENT_USER!.uid).setValue(true)
        // add checked user to the following to the current user
        DB_Following.child(Api.User.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unfollow(withCheckedUserId id: String){
        // move currrent user to the followers to the checked user
        DB_Followers.child(id).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        // move   checked user to the following to the current user
        DB_Following.child(Api.User.CURRENT_USER!.uid).child(id).setValue(NSNull())
        Api.UserPosts.DB_UserPosts.child(id).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dict  = snapshot.value as? [String:Any]{
                for key in dict.keys{
                    Database.database().reference().child("postsFeed").child(Api.User.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        })
    }
    
    func isFollowing(id:String, completed: @escaping (Bool) -> Void){
        DB_Followers.child(id).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
                (snapshot) in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            }else {
                completed(true)
            }
        })
    }
    
    
    
}// class close
