//
//  Api.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 13/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
class Api{
    static var User = UserApi()
    static var Post = PostApi()
    static var Comment = CommentApi()
    static var PostComment = PostCommentApi()
    static var UserPosts = UserPostsApi()
    static var Follow = FollowApi()

}
