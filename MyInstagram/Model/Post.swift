//
//  Post.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 01/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
import FirebaseAuth
class Post {
    var id: String?
    var photoUrl: String?
    var description:  String?
    var userId: String?
    var likeCount: Int?
    var likes: Dictionary<String,Any>?
    var isLiked: Bool?
}

extension Post {
    static func formatPost(dict:[String:Any],key:String) -> Post {
        let post  = Post()
        post.id = key
        post.description = dict["desc"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.userId = dict["userId"] as? String
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUserId] != nil
            }else {
                post.isLiked = false
            }
        }
        return post
    }
}
