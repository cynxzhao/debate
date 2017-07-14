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
    
    @IBAction func userAdded(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print ("appear")
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
                    print(self.users)
                })
            }

    override func viewDidDisappear(_ animated: Bool) {
        print("disappear")
        self.users = []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toCreate" {
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let user = users[indexPath.row]
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
        print(users.count)
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        // 1
        let row = indexPath.row
        
        // 2
        let user = users[row]
        
        cell.usernameLabel.text = user.username
        cell.nameLabel.text = user.name
        
        return cell
    }
}

    extension SearchMembersViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40
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
