//
//  test.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 29/09/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation

// clicked signup
@IBAction func signupBtn_click(_ sender: Any) {
    
    Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion:{
        (user, error) in
        if error != nil || user == nil {
            print(String(describing: error?.localizedDescription))
            return
        }
        let userId = user?.user.uid
        let storage = Storage.storage().reference(forURL: "gs://minstagram-72c09.appspot.com").child("avatar_image").child(userId!)
        
        if let profileImg = self.selectedAvatar, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            storage.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }else{
                    storage.downloadURL(completion: {
                        (url,error) in
                        guard let downloadUrl = url else {
                            print("Error: \(error?.localizedDescription)")
                            return
                        }
                        let avatarUrl = downloadUrl.absoluteString
                        self.registerUser(avatarUrl: avatarUrl, username:self.usernameTxt.text!, email: self.emailTxt.text!, userId: userId)
                    })
                }
            }
        }
    }
}
            
           
            
}



