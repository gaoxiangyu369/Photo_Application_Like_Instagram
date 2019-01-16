//
//  UserApi.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 13/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi{
    var DB_Users = Database.database().reference().child("users")
    
    
    func getUser(withId userId:String, completion: @escaping (UserModel)-> Void){
        DB_Users.child(userId).observeSingleEvent(of: .value, with: {
            (snapshot: DataSnapshot) in
            if let usersDict = snapshot.value as? [String:Any]{
                let newUser =
                    UserModel.formatUser(dict:usersDict,key:snapshot.key)
                completion(newUser)
            }
        })
    }
    
    func searchUsers(withTxt text:String,completion: @escaping (UserModel)-> Void){
        DB_Users.queryOrdered(byChild:"usernameLower").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").observeSingleEvent(of: .value, with: {
                snapshot in
                snapshot.children.forEach({
                  (snap) in
                    let child = snap as! DataSnapshot
                    if let dict = child.value as? [String:Any]{
                        let user =
                            UserModel.formatUser(dict:dict,key:snapshot.key)
                        completion(user)
                    }
                })
        })
    }

    
    func getTotalUserNum(completion: @escaping (Int)-> Void){
        DB_Users.observe(DataEventType.value) { (snapshot) in
            completion(Int(snapshot.childrenCount))
        }
    }
    
    func getUsers(completion: @escaping (UserModel) -> Void){
        DB_Users.observe(.childAdded, with: {
            (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String:Any]{
                let user =
                    UserModel.formatUser(dict:dict,key:snapshot.key)
                completion(user)
            }
        })
    }
    
    func getCurrentUser(completion: @escaping (UserModel)-> Void){
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        DB_Users.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            (snapshot: DataSnapshot) in
            if let usersDict = snapshot.value as? [String:Any]{
                let currentUser = UserModel.formatUser(dict:usersDict,key:snapshot.key)
                completion(currentUser)
            }
        })
    }
    
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser{
            return currentUser
        }
        return nil
    }
    
    var DB_CurrentUser: DatabaseReference?{
        guard let currentUser = Auth.auth().currentUser else{
            return nil
        }
        return DB_Users.child(currentUser.uid)
    }
}
