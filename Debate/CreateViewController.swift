//
//  CreateViewController.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateViewController: UIViewController {

    @IBOutlet weak var groupNameTextField: UITextField!
    
    var group : Group?
    var users : [String]? = [User.current.username]
    var user : User?
    
    
    @IBAction func groupCreated(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let groupName = groupNameTextField.text,
            !groupName.isEmpty,
            let users = users
            else { return }
        GroupService.create(firUser, groupName: groupName, users: users) { (group) in
            guard let group = group else { return }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = user {
            users?.append((user.username))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
