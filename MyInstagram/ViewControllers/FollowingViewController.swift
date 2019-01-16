//
//  FollowingViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 17/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var users : [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFollowing()
        tableView.rowHeight = 100
        // Do any additional setup after loading the view.
    }
    
    func loadFollowing(){
        Api.Follow.getFollowing(completion: {
            user in
            self.isFollowing(id: user.id!, completed: { value in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })
            
        })
    }
    
    func isFollowing(id:String, completed: @escaping (Bool) -> Void){
        Api.Follow.isFollowing(id: id, completed: completed)
    }
    
    
    
}

extension FollowingViewController: UITableViewDataSource{
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

