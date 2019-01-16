//
//  SearchUserViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 16/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {

    var searchBar = UISearchBar()
    var users: [UserModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUsers()
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        

        searchBar.frame.size.width = view.frame.size.width - 70
        
        let search = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = search
        
        // Do any additional setup after loading the view.
    }
    
    func searchUsers(){
        if let searchTxt = searchBar.text?.lowercased(){
            self.users.removeAll()
            self.tableView.reloadData()
            Api.User.searchUsers(withTxt: searchTxt, completion: {
                (user) in
                self.isFollowing(id: user.id!, completed: { (value) in
                    user.isFollowing = value
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func isFollowing(id:String, completed: @escaping (Bool) -> Void){
        Api.Follow.isFollowing(id: id, completed: completed)
    }

}

extension SearchUserViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchUsers()
        print(users)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUsers()
    }
}

extension SearchUserViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell", for: indexPath) as! DiscoverTableViewCell
        let user  = users[indexPath.row]
        cell.user = user
        return cell
    }
}













