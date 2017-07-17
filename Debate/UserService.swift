//
//  UserServices.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct UserService {
    static func create(_ firUser: FIRUser, username: String, name: String, aboutMe: String, completion: @escaping (User?) -> Void) {
    let userAttrs = ["username": username,
                     "name" : name,
                     "aboutMe" : aboutMe,
                     "email": Auth.auth().currentUser!.email!,
                     "groups": ["abc"]] as [String : Any]
    
    let ref = Database.database().reference().child("users").child(firUser.uid)
    ref.setValue(userAttrs) { (error, ref) in
        if let error = error {
            assertionFailure(error.localizedDescription)
            return completion(nil)
        }
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(snapshot: snapshot)
            completion(user)
        })
    }
        
}

}
