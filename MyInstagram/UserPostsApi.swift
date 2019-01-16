//
//  UserPosts.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 14/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserPostsApi{
    var DB_UserPosts = Database.database().reference().child("userPosts")
    func getPostsNum(withId id:String,completion: @escaping (Int)->Void){
        DB_UserPosts.child(id).observe(DataEventType.value, with: { (snapshot) in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
}
