//
//  CommentApi.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 13/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi{
    var DB_Comments = Database.database().reference().child("comments")
    
    func observeComments(withPostId commentId: String,completion: @escaping (Comment) -> Void){
        DB_Comments.child(commentId).observeSingleEvent(of: .value, with:{
         snapshot in
            if let commentDict = snapshot.value as? [String:Any]{
                let newComment = Comment.formatComment(dict: commentDict)
                completion(newComment)
            }
        })
    }
}
