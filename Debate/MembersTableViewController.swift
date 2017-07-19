//
//  MembersTableViewController.swift
//  Debate
//
//  Created by Cindy Zhao on 7/14/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MembersTableViewController: UITableViewController {

    var group : Group?
    var users = [String]()
    var user : User?
    var userSet = Set<String>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var key: String = ""
        
        // retrieves users in group clicked
        let ref = Database.database().reference().child("groups")
        ref.observe(.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snap in snapshot {
                let value = snap.value as? NSDictionary
                if value?["groupName"] as? String == self.group?.groupName {
                    
                    key = snap.key
                    
                    self.users = (value?["users"] as? [String])!
                    
                    self.userSet = Set(self.users)
                    
                    // adds new user to list
                    if let user = self.user {
                        self.userSet.insert(user.username)
                    }
                    
                    self.users = Array(self.userSet)
                    self.tableView.reloadData()
                    let ref1 = Database.database().reference().child("groups").child(key)
                    ref1.updateChildValues(["users" : self.users])
                    
                }
            }
        })

//        memberAdded()
    }
    
//    func memberAdded() {
//        var key: String = ""
//        
//        // retrieves users in group clicked
//        let ref = Database.database().reference().child("groups")
//        ref.observe(.value, with: { (snapshot) in
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//                else { return }
//            for snap in snapshot {
//                let value = snap.value as? NSDictionary
//                if value?["groupName"] as? String == self.group?.groupName {
//                    
//                    key = snap.key
//                    
//                    self.users = (value?["users"] as? [String])!
//                    
//                    self.userSet = Set(self.users)
//                    
//                    // adds new user to list
//                    if let user = self.user {
//                        self.userSet.insert(user.username)
//                    }
//                    
//                    self.users = Array(self.userSet)
//                    self.tableView.reloadData()
//                    let ref1 = Database.database().reference().child("groups").child(key)
//                    ref1.updateChildValues(["users" : self.users])
//                    
//                }
//            }
//        })
// 
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(MembersTableViewController.memberAdded), name: NSNotification.Name(rawValue: "addedAll"), object: nil)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersTableViewCell", for: indexPath) as! MembersTableViewCell
        
        // 1
        let row = indexPath.row
        
        // 2
        let user = users[row]
        
        cell.usernameLabel.text = user
        
        return cell
    }
    
    @IBAction func unwindToMembersViewController(_ segue: UIStoryboardSegue) {
        
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view DELETE FUNCTION DOES NOT WORK YET
    override     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let user = users[row]
            userSet.remove(user)
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
