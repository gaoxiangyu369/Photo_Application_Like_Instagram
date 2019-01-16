//
//  SearchViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 17/09/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController {

    var users : [UserModel] = []
    var followers: [Int] = []
    var recom : [UserModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recommended User"
        getPopularUsers(withid: Api.User.CURRENT_USER!.uid)
        
    }
    
    func loadRecUsers(){
        let maxCount = followers.max()!
        for (index,count) in followers.enumerated()  {
            if count == maxCount {
                self.isFollowing(id: self.users[index].id!, completed: { value in
                    self.users[index].isFollowing = value
                    self.recom.append(self.users[index])
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func isFollowing(id:String, completed: @escaping (Bool) -> Void){
        Api.Follow.isFollowing(id: id, completed: completed)
    }
    
    func getPopularUsers(withid id:String){
        Api.User.getTotalUserNum { (total) in
            print(total)
            Api.User.getUsers { (user) in
                if user.id != id {
                    Api.Follow.getCount(withId: user.id!, completion: { (count) in
                        self.followers.append(count)
                        self.users.append(user)
                        if self.users.count == total-1 {
                            self.loadRecUsers()
                        }
                    })
                }
            }
        }
    }

} //close

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recom.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell", for: indexPath) as! DiscoverTableViewCell
        let user  = recom[indexPath.row]
        cell.user = user
        return cell
    }
}
