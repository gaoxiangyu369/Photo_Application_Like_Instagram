//
//  SignUpViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 15/09/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    // avatar image
    @IBOutlet weak var avatarImg: UIImageView!
    
    // user info textfield
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var firstnameTxt: UITextField!
    @IBOutlet weak var lastnameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatpasswordTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    //scrollvies
    @IBOutlet weak var scrollview: UIScrollView!
    // button
    @IBOutlet weak var signupBtn: UIButton!
    
    
    var selectedAvatar: UIImage?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        avatarImg.layer.cornerRadius = 50
        avatarImg.clipsToBounds = true
        
        let tapAvatar = UITapGestureRecognizer(target: self, action:  #selector(SignUpViewController.onSelectAvatarImg))
        avatarImg.addGestureRecognizer(tapAvatar)
        avatarImg.isUserInteractionEnabled = true
        
        signupBtn.isEnabled = false
        signupBtn.backgroundColor = UIColor.white
        signupBtn.setTitleColor(UIColor.darkText , for: UIControlState.normal)
        dealTxtField()
    }
    
    // Listening the changes to the textfeilds
    func dealTxtField() {
        usernameTxt.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        emailTxt.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        passwordTxt.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControlEvents.editingChanged)
    }
    
    
    // Once the text feild changed, do sth.
    @objc func textFieldChanged(){
        guard let username = usernameTxt.text,!username.isEmpty, let email = emailTxt.text,!email.isEmpty, let password = passwordTxt.text, !password.isEmpty else {
            signupBtn.backgroundColor = UIColor.white
            signupBtn.setTitleColor(UIColor.darkText , for: UIControlState.normal)
            signupBtn.isEnabled = false
            return
        }
        signupBtn.backgroundColor = UIColor.lightGray
        signupBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        signupBtn.isEnabled = true
    }
    
    
    @objc func onSelectAvatarImg() {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }
    
    // clicked go back to login
    @IBAction func cancelBtn_click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    // clicked signup
    @IBAction func signupBtn_click(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction:false)
    
        Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion:{
            (user, error) in
            if error != nil || user == nil {
                ProgressHUD.showError(error!.localizedDescription)
                print(String(describing: error?.localizedDescription))
                return
            }
            let userId = user?.user.uid
            let storage = Storage.storage().reference(forURL: "gs://minstagram-72c09.appspot.com").child("avatar_image").child(userId!)
            
            if let profileImg = self.selectedAvatar, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                storage.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        ProgressHUD.showError(error!.localizedDescription)
                        print(error!.localizedDescription)
                        return
                    }else{
                        storage.downloadURL(completion: {
                            (url,error) in
                            guard let downloadUrl = url else {
                                ProgressHUD.showError(error!.localizedDescription)
                                print("Error: \(String(describing: error?.localizedDescription))")
                                return
                            }
                            let avatarUrl = downloadUrl.absoluteString
                            self.registerUser(avatarUrl: avatarUrl, username:self.usernameTxt.text!, email: self.emailTxt.text!, userId: userId!)
                        });
                    }
                });
            }else{
                ProgressHUD.showError("Please set an avatar!")
            }
        });
    }
    
    
    func registerUser(avatarUrl:String, username: String, email:String, userId:String){
        let database = Database.database().reference()
        let usersReference = database.child("users")
        let newUserReference = usersReference.child(userId)
        newUserReference.setValue(["username": username,"usernameLower":username.lowercased() , "email": email, "avatarUrl": avatarUrl ])
        self.performSegue(withIdentifier: "signupToTab", sender:nil)
    }
    
}


extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedAvatar = image
            avatarImg.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
