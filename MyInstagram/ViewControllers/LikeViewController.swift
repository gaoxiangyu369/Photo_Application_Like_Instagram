//
//  LikeViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 17/09/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    
    var users: [UserModel] = []
    var followers: [UserModel] = []
    var followings: [UserModel] = []
    var followersID: [String] = []
    var followingsID: [String] = []
    var followingEvent: [String] = []
    var followerEvent: [String] = []
    var data: [String] = []
    
    
    @IBOutlet weak var contentTable: UITableView!
    @IBOutlet weak var segControl: UISegmentedControl!
    

    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.data = self.followingEvent
        }else{
            self.data = self.followerEvent
        }
        contentTable.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTable.delegate = self
        contentTable.dataSource = self

        getUserInfo()
        contentTable.reloadData()
    }
    
    
    func getUserInfo(){
        Api.User.getCurrentUser(completion: {
            (user) in
            self.users.append(user)
            Api.Follow.getFollowing(completion: {
                user_following in
                self.isFollowing(id: user_following.id!, completed: { value in
                    user_following.isFollowing = value
                    self.followings.append(user_following)
                    self.followingsID.append(user_following.id!)
                    Api.Post.observePosts(completion: {
                        post in
                        var subjectUser: [UserModel] = []
                        var activityType: String = ""
                        
                        let likeUserID = post.likes?.keys
                        for userID in self.followingsID {
                            if likeUserID != nil && likeUserID!.contains(userID) {
                                Api.User.getUser(withId: userID, completion: {
                                    user_deep in
                                    subjectUser.append(user_deep)
                                    activityType = "likes the post"
                                    self.followingEvent.append("\(subjectUser[0].avatarUrl!), \(subjectUser[0].username!), \(activityType),\(post.photoUrl!)")
                                    self.contentTable.reloadData()
                                })
                                
                            }else if post.userId! == userID {
                                Api.User.getUser(withId: userID, completion: {
                                    user_deep in
                                    subjectUser.append(user_deep)
                                    activityType = "post an image"
                                    self.followingEvent.append("\(subjectUser[0].avatarUrl!), \(subjectUser[0].username!), \(activityType),\(post.photoUrl!)")
                                    self.contentTable.reloadData()
                                })
                            }
                        }
                        self.contentTable.reloadData()
                    })
                    self.contentTable.reloadData()
                })
                self.contentTable.reloadData()
            })
            Api.Post.observePosts(completion: {
                post in
                if post.userId! == self.users[0].id! {
                    if let likeUserID = post.likes?.keys {
                        for userID in likeUserID {
                            Api.User.getUser(withId: userID, completion: {
                                user_deep in
                                let activityType = "likes the post"
                                self.followerEvent.append("\(user_deep.avatarUrl!), \(user_deep.username!), \(activityType),\(post.photoUrl!)")
                                self.contentTable.reloadData()
                            })
                        }
                    }
                    
                }
                self.contentTable.reloadData()
            })
            self.contentTable.reloadData()
        })
        
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue", size: 24.0)!, forKey: NSAttributedStringKey.font as NSCopying)
        segControl.setTitleTextAttributes(attr as? [AnyHashable : Any], for: .normal)
        contentTable.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func isFollowing(id:String, completed: @escaping (Bool) -> Void){
        Api.Follow.isFollowing(id: id, completed: completed)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTable.dequeueReusableCell(withIdentifier: "activityTableCell") as! LikeTableViewCell
        let content = self.data[indexPath.row].components(separatedBy: ",")
        cell.showCell(avatar: content[0], username: content[1], activityType: content[2], imgURL: content[3])
        return cell
    }
}
