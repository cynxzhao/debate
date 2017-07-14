//
//  HomeTableViewController.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeTableViewController: UITableViewController {
        
    var groups = [Group]()
    
    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        super.viewWillAppear(animated)
        actOnViewController()
    }
    
    func actOnViewController() {
        var groupIDs = [String]()
        self.groups = []
        let ref = Database.database().reference().child("users").child(User.current.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                groupIDs = user.groups!
                let ref1 = Database.database().reference().child("groups")
                ref1.observe(.value, with: { (snapshot) in
                    guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                        else { return }
                    //print(snapshot[0])
                    for snap in snapshot {
                        for id in groupIDs {
                            if id == snap.key {
                                let group = Group(snapshot: snap)
                                self.groups.append(group!) 
                            }
                        }
                    }
                    self.tableView.reloadData()
                    groupIDs = []
                })
            }
        })
        
    }
    
    override func viewDidLoad() {
        //print("didload")
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.actOnViewController), name: NSNotification.Name(rawValue: "uploaded"), object: nil)

    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        var groupIDs = [String]()
//        
//        let ref = Database.database().reference().child("users").child(User.current.uid)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let user = User(snapshot: snapshot) {
//                groupIDs = user.groups!
//                let ref1 = Database.database().reference().child("groups")
//                ref1.observe(.value, with: { (snapshot) in
//                    guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//                        else { return }
//                    //print(snapshot[0])
//                    for snap in snapshot {
//                        for id in groupIDs {
//                            if id == snap.key {
//                                let group = Group(snapshot: snap)
//                                self.groups.append(group!)
//                            }
//                        }
//                    }
//                    self.tableView.reloadData()
//                })
//                
//            }
//        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    //}
    
    override func viewDidDisappear(_ animated: Bool) {
        print("disappear")
        self.groups = []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        // 1
        let row = indexPath.row
        
        // 2
        let group = groups[row]
        
        cell.groupNameLabel.text = group.groupName
        cell.membersLabel.text = "\(group.users.count) members"
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "unwindToListCreateViewController" {
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let group = groups[indexPath.row]
                // 3
                let SentNewsTableViewController = segue.destination as! SentNewsTableViewController
                // 4
                SentNewsTableViewController.group = group.groupName
            }
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
