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
            var usernameTaken = false
            let ref1 = Database.database().reference()
            ref1.child("users").queryOrdered(byChild: "username").queryEqual(toValue: usernameTextField.text).observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists(){
                    print("it exists")
                    usernameTaken = true
                    let alert = UIAlertController(title: "Error", message: "Username already exists, so it could not be updated", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    usernameTaken = false
                    let userAttr = ["username": self.usernameTextField.text]
                    ref.updateChildValues(userAttr)
                    
                    UserService.updateUsername(new: self.usernameTextField.text!, completion: { (all) in
                        User.current.username = self.usernameTextField.text!
                    })
                    
                }
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
