//
//  HomeViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 17/09/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    var posts = [Post]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.estimatedRowHeight = 500
        homeTableView.rowHeight = UITableViewAutomaticDimension
        homeTableView.dataSource = self
        showPosts()
    }
    
    func showPosts(){
        PostApi().observePosts(completion: {
            post in
            guard let postUserId = post.userId else{
                return
            }
            self.getUser(userId: postUserId, completed: {
                self.posts.append(post)
                self.homeTableView.reloadData()
            })
            
        })
    }
    
    func getUser(userId: String, completed:  @escaping () -> Void ) {
        UserApi().getUser(withId: userId, completion: {
            user in
            self.users.append(user)
            completed()
        })
    }
    
    // Clicking the Logout button
    @IBAction func LogoutBtn(_ sender: Any) {
        Authentication.logout(OnSuccess: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signin = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signin, animated: true, completion: nil)
        }, OnFailure: {
            (error) in
            ProgressHUD.showError(error)
        })
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
            let commentViewController = segue.destination as! CommentViewController
            let postId = sender  as! String
            commentViewController.postId = postId
        }
        if segue.identifier == "likeSegue" {
            let likedPeople = segue.destination as! LikedPeopleViewController
            let postId = sender  as! String
            likedPeople.postId = postId
        }
    }
    
} // class close

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! HomeTableViewCell
        let post  = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.homeViewController = self
        return cell
    }
}

















