//
//  CreateViewController.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateViewController: UIViewController {

    @IBOutlet weak var groupNameTextField: UITextField!
    
    var userSet: Set<String> = [User.current.username]
    
    var group : Group?
    var users : [String]?
    var user : User?
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func groupCreated(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let groupName = groupNameTextField.text,
            !groupName.isEmpty,
            let users = users
            else { return }
        
        let ref = Database.database().reference()
        
        var groupNameTaken = false
        ref.child("groups").queryOrdered(byChild: "groupName").queryEqual(toValue: groupName).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists(){
                groupNameTaken = true
                let alert = UIAlertController(title: "Error", message: "Group name already exists, please choose a new one", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                groupNameTaken = false
                GroupService.create(firUser, groupName: groupName, users: users) { (group) in
                    guard let group = group else { return }
                }
                self.navigationController?.popViewController(animated: true)

            }
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userAdded()
    }
    
    func userAdded() {
    if let user = user {
        userSet.insert(user.username)
        }
        users = Array(userSet)
        self.tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(CreateViewController.userAdded), name: NSNotification.Name(rawValue: "added"), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToListCreateViewController(_ segue: UIStoryboardSegue) {

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createTableViewCell", for: indexPath) as! CreateTableViewCell
        
        // 1
        let row = indexPath.row
        
        // 2
        let user = users?[row]
        
        cell.memberNameLabel.text = user!
        return cell
    }
}

extension CreateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            users!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}

