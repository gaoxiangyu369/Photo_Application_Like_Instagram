//
//  Comment.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 04/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
class Comment {
    var comment: String?
    var userId:  String?
}

extension Comment {
    static func formatComment(dict:[String:Any]) -> Comment {
        let comment  = Comment()
        comment.comment = dict["comment"] as? String
        comment.userId = dict["userId"] as? String
        return comment
    }
}
