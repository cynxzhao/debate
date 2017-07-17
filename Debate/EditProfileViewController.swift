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
            print ("name")
            let userAttr = ["name" : nameTextField.text]
            
            ref.updateChildValues(userAttr)
            User.current.name = nameTextField.text!
        }
        
        if usernameTextField.text != "" {
            print ("username")
            let userAttr = ["username": usernameTextField.text]
            
            ref.updateChildValues(userAttr)
            User.current.username = usernameTextField.text!
        }
        
        if aboutMeTextField.text != "" {
            print("about Me")
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
