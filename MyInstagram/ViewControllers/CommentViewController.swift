//
//  CommentViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 04/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit
class CommentViewController: UIViewController {
    
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var commentTxt: UITextField!
    @IBOutlet weak var sendCommentBtn: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    
    var comments = [Comment]()
    var users = [UserModel]()
    var postId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comment"
        commentTableView.dataSource = self
        commentTableView.estimatedRowHeight = 86
        emptyComment()
        sendCommentBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendCommentBtn.isEnabled = false
        dealTextField()
        showComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification){
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.bottomConstrain.constant = keyboardFrame!.height
        })
    }

    @objc func keyboardWillHide(_ notification:NSNotification){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.bottomConstrain.constant = 0
        })
    }
    
    // To hide the bottom tab bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func showComments(){
        Api.PostComment.DB_PostComment.child(self.postId).observe(.childAdded, with: {
            snapshot in
            Api.Comment.observeComments(withPostId: snapshot.key, completion: {
                comment in
                self.getUser(userId: comment.userId! , completed: {
                    self.comments.append(comment)
                    self.commentTableView.reloadData()
                })
            })
        })
    }
    
    func getUser(userId:String, completed: @escaping ()-> Void){
        Api.User.getUser(withId: userId, completion: {
            user in
            self.users.append(user)
            completed()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    // To send the comment
    @IBAction func sendComment(_ sender: Any) {
        sendDataToDatabase()
    }
    

    // Save comment to the database
    func sendDataToDatabase(){
        let commentsReference = Api.Comment.DB_Comments
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId)
        
        guard let currentUser = Api.User.CURRENT_USER else{
            return
        }
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["userId": currentUserId,"comment": commentTxt.text!], withCompletionBlock: {
            (error,ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            //let fakedPostId = "LNtwFH2qa7BVKR0PzAH"
            let postCommentRef = Api.PostComment.DB_PostComment.child(self.postId).child(newCommentId)
            postCommentRef.setValue(["userId": currentUserId, "commentTxt": self.commentTxt.text!], withCompletionBlock: {
                (error, reference) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            self.emptyComment()
            self.view.endEditing(true)
        })
    }
    
    // Empty the comment text field
    func emptyComment(){
        self.commentTxt.text = ""
        sendCommentBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendCommentBtn.isEnabled = false
    }
    
    // Comment Text Field is empty  - send button is disabled
    // Comment Text Field is filled - send button is enabled
    @objc func textFieldChanged(){
        if let commentTxt = commentTxt.text,!commentTxt.isEmpty {
            sendCommentBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
            sendCommentBtn.isEnabled = true
            return
        }
        sendCommentBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendCommentBtn.isEnabled = false
    }
    
    // Watchin the comment text field changes
    func dealTextField() {
        commentTxt.addTarget(self, action: #selector(self.textFieldChanged), for: UIControlEvents.editingChanged)
    }

    

}// class close




extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for:indexPath) as!
        CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
}














