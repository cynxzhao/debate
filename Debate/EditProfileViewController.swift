//
//  EditPersonalInfoViewController.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditProfileViewController : UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var aboutMeTextField: UITextField!

    @IBAction func editSaved(_ sender: UIBarButtonItem) {
        let ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        
        if nameTextField.text != "" {
            let userAttr = ["name" : nameTextField.text]
            
            ref.updateChildValues(userAttr)
            User.current.name = nameTextField.text!
        }
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
//                    groupIDs = []
//                })
//            }
//        })
        
        if usernameTextField.text != "" {
            let userAttr = ["username": usernameTextField.text]
            ref.updateChildValues(userAttr)
            User.current.username = usernameTextField.text!
            
                let ref2 = Database.database().reference().child("users").child(User.current.uid).child("groups")
                ref2.observe(.value, with: { (snapshot) in
                    guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                        else { return }
                    for group in snapshot {
                        print(group.value as? String)
                         let ref3 = Database.database().reference().child("groups").child((group.value as? String)!).child("users")
                        ref3.observe(.value, with: { (users) in
                            guard var users = users.children.allObjects as? [String]
                                else {return}
                            for user in users {
                                var index = 0

                                if user == User.current.username {
                                users[index] = User.current.username
                                index = 0
                                }
                                index += 1
                            }
                        })
                    }
//                })
//
            })
        }
        
        if aboutMeTextField.text != "" {
            let userAttr = ["aboutMe" : aboutMeTextField.text]
            
            ref.updateChildValues(userAttr)
            User.current.aboutMe = aboutMeTextField.text!
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
