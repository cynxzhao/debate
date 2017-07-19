//
//  SearchMembersViewController.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchMembersViewController: UIViewController {

    var users = [User]()
    var filteredUsers = [User]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = users.filter { user in
            return user.username.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "toCreate", sender: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            //print(snapshot[0])
            for snap in snapshot {
                let user = User(snapshot: snap)
                self.users.append(user!)
            }
            self.tableView.reloadData()
        })
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.users = []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toCreate" {
                //self.performSegue(withIdentifier: "toCreate", sender: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "added"), object: self)
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let user: User
                if searchController.isActive && searchController.searchBar.text != "" {
                    user = filteredUsers[indexPath.row]
                } else {
                    user = users[indexPath.row]
                }
                // 3
                let createViewController = segue.destination as! CreateViewController
                // 4
                createViewController.user = user
                
            }
        }
    }
}

extension SearchMembersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        var user : User
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        cell.usernameLabel.text = user.username
        cell.nameLabel.text = user.name
        
        return cell
    }

}

    extension SearchMembersViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60
    }
}

extension SearchMembersViewController : UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
