//
//  HelperStorage.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 15/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import Foundation
import FirebaseStorage
class HelperStorage{
    
    static func uploadPhotoToDatabase(data:Data, desc:String, onSuccess: @escaping () -> Void){
        let photoId = NSUUID().uuidString
        let photoNode = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoId)
        photoNode.putData(data,metadata:nil,completion:{
            (metadata,error) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            photoNode.downloadURL(completion: { (url, error) in
                guard let downloadUrl = url else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                let photoPostedUrl = downloadUrl.absoluteString
                self.saveDataTodataBase(photoUrl: photoPostedUrl, desc: desc, onSuccess: onSuccess)
            })
        })
    }
    
    static func saveDataTodataBase(photoUrl: String, desc:String, onSuccess: @escaping () -> Void){
        let newPostId = Api.Post.DB_Posts.childByAutoId().key
        let newPostNode = Api.Post.DB_Posts.child(newPostId)
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        newPostNode.setValue(["userId": currentUserId,"photoUrl": photoUrl,"desc": desc], withCompletionBlock: {
            (error,ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
//            Api.PostsFeed.DB_PostsFeed.child(currentUserId).child(newPostId).setValue(true)
            
            let userPostsNode = Api.UserPosts.DB_UserPosts.child(currentUserId).child(newPostId)
            userPostsNode.setValue(true, withCompletionBlock: {(error,ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            ProgressHUD.showSuccess("Post Uploaded Sucessfully")
            onSuccess()
        })
    }
}// class close
