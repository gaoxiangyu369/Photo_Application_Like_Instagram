//
//  User.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 04/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
class UserModel {
    var email: String?
    var username: String?
    var avatarUrl: String?
    var id: String?
    var isFollowing: Bool? = false
}

extension UserModel {
    static func formatUser(dict:[String:Any],key: String) -> UserModel {
        let user = UserModel()
        user.id = key
        user.email = dict["email"] as? String
        user.username = dict["username"] as? String
        user.avatarUrl = dict["avatarUrl"] as? String
        return user
    }
}
