//
//  LikedPeopleViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 17/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class LikedPeopleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var users : [UserModel] = []
    var postId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLikedPeople()

    }
    
    
    func loadLikedPeople(){
        Api.Post.getPost(withId: self.postId) { (post) in
            if let likedKey = post.likes{
                for item in likedKey {
                    Api.User.getUser(withId: item.key, completion: { (user) in
                        if user.id! != Api.User.CURRENT_USER?.uid{
                            self.isFollowing(id: user.id!, completed: { value in
                                user.isFollowing = value
                                self.users.append(user)
                                self.tableView.reloadData()
                            })
                        }
                        
                    })
                }
            }
        }
    }
    
    func isFollowing(id:String, completed: @escaping (Bool) -> Void){
        Api.Follow.isFollowing(id: id, completed: completed)
    }
    

}// close

extension LikedPeopleViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell", for: indexPath) as! DiscoverTableViewCell
        let user  = users[indexPath.row]
        cell.user = user
        return cell
    }
}
