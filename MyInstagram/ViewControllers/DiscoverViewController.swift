//
//  DiscoverViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 15/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    var users : [UserModel] = []
    @IBOutlet weak var discoverTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDiscoveredUsers()
        print("discover view controller is loaded again")
        discoverTableView.rowHeight = 100
        discoverTableView.dataSource = self
    }
    
    func loadDiscoveredUsers(){
        Api.User.getUsers(completion: { (discoveredUser) in
            if discoveredUser.id != Api.User.CURRENT_USER?.uid{
                self.isFollowing(id: discoveredUser.id!, completed: { value in
                    discoveredUser.isFollowing = value
                    print(value)
                    self.users.append(discoveredUser)
                    self.discoverTableView.reloadData()
                })
            }
        })
    }
    
    func isFollowing(id:String, completed: @escaping (Bool) -> Void){
        Api.Follow.isFollowing(id: id, completed: completed)
    }
    

} // class close

extension DiscoverViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell", for: indexPath) as! DiscoverTableViewCell
        let checkedUser  = users[indexPath.row]
        cell.user = checkedUser
        return cell
    }
}

