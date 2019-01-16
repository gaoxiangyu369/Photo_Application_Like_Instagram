//
//  UploadViewController.swift
//  MyInstagram
//
//  Created by Liang Zhang on 13/10/18.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class UploadViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var captionField: UITextView!
    
    @IBOutlet weak var photo: UIImageView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = selectedImage
        captionField.delegate = self
        captionField.returnKeyType = .done
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(shareButton_TouchUpInside))
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if captionField.text == "Write a caption..." {
            captionField.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if captionField.text == "" {
            captionField.text = "Write a caption..."
        }
    }
    
    @objc func shareButton_TouchUpInside() {
        ProgressHUD.show("Waiting...", interaction: false)
        if let photoPost = self.selectedImage, let imageData = UIImageJPEGRepresentation(photoPost, 0.1) {
            let photoId = NSUUID().uuidString
            let storage = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoId)
            
            storage.putData(imageData, metadata: nil, completion: {
                (metadata,error) in
                if error != nil {
                    print(error!.localizedDescription)
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                storage.downloadURL(completion: {
                    (url, error) in
                    guard let downloadUrl = url else {
                        print("Error: \(String(describing: error?.localizedDescription))")
                        ProgressHUD.showError(error!.localizedDescription)
                        return
                    }
                    let photoPostedUrl = downloadUrl.absoluteString
                    self.sendDataToDatabase(photoUrl:photoPostedUrl)
                })
            })
        }else {
            ProgressHUD.showError("Profile Image can't be empty")
        }
        
    }
    
    func sendDataToDatabase(photoUrl:String){
        let database = Database.database().reference()
        let postsReference = database.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId)
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        let currentUserId = currentUser.uid
        newPostReference.setValue(["userId": currentUserId,"photoUrl": photoUrl,"desc": captionField.text!], withCompletionBlock: {
            (error,ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            let userPostsNode = Api.UserPosts.DB_UserPosts.child(currentUserId).child(newPostId)
            userPostsNode.setValue(true, withCompletionBlock: {(error,ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            ProgressHUD.showSuccess("Uploaded Sucessfully")
            self.tabBarController?.selectedIndex = 0
        })
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
