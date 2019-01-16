//
//  Authentication.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 29/09/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD

class Authentication {
    
    // Sign In
    static func signin(email:String, password: String, OnSuccess: @escaping() -> Void,
                OnFailure: @escaping(_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail:email, password:password, completion: {
            (user,error) in
            if (error != nil) {
                OnFailure(error!.localizedDescription)
                return
            }
            OnSuccess()
        })
    }
    
    static func logout(OnSuccess: @escaping() -> Void,
                       OnFailure: @escaping(_ errorMessage: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            OnSuccess()
        }catch let logoutError {
            OnFailure(logoutError.localizedDescription)
        }
    }
    
    // Sign Up
//    static func signup(username: String, email: String, password: String, OnSuccess: @escaping() -> Void, OnFailure: @escaping(_ errorMessage: String?) -> Void){
//        Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion:{
//            (user, error) in
//            if error != nil || user == nil {
//                print(String(describing: error?.localizedDescription))
//                return
//            }
//
//            let userId = user?.user.uid
//            let storage = Storage.storage().reference(forURL: "gs://minstagram-72c09.appspot.com").child("avatar_image").child(userId!)
//
//            if let profileImg = self.selectedAvatar, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
//                storage.putData(imageData, metadata: nil, completion: { (metadata, error) in
//                    if error != nil {
//                        print(error!.localizedDescription)
//                        return
//                    }else{
//                        storage.downloadURL(completion: {
//                            (url,error) in
//                            guard let downloadUrl = url else {
//                                print("Error: \(String(describing: error?.localizedDescription))")
//                                return
//                            }
//                            let avatarUrl = downloadUrl.absoluteString
//                            self.registerUser(avatarUrl: avatarUrl, username:self.usernameTxt.text!, email: self.emailTxt.text!, userId: userId!)
//                        });
//                    }
//                });
//            }
//        });
//    }
    
    
    
    
    // Helper of Sign Up
//    func registerUser(avatarUrl:String, username: String, email:String, userId:String){
//        let database = Database.database().reference()
//        let usersReference = database.child("users")
//        let newUserReference = usersReference.child(userId)
//        newUserReference.setValue(["username": self.usernameTxt.text!, "email": self.emailTxt.text!, "avatarUrl": avatarUrl ])
//        self.performSegue(withIdentifier: "signupToTab", sender:nil)
//    }
    
    
}// class close
