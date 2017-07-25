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
    
    static func addToGroup(uid: String, groupID: String) {
        let ref3 = Database.database().reference().child("users").child(uid)
        ref3.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                var oldGroup = user.groups
                if(oldGroup![0] == "abc") {
                    var newArray = [String]()
                    newArray.append(groupID)
                    let userAttrs = ["groups" : newArray]
                    ref3.updateChildValues(userAttrs as [String: Any])
                }  else {
                    oldGroup!.append(groupID)
                    let userAttrs = ["groups" : oldGroup!]
                    ref3.updateChildValues(userAttrs as [String: Any])
                }
            }
        })
    }
    
    static func leaveGroup(groupID: String, username: String) {
  
        
            let ref = Database.database().reference().child("groups").child(groupID).child("users")
            
            ref.queryEqual(toValue: username).observe(.childAdded, with: { (snapshot) in
                
                snapshot.ref.removeValue(completionBlock: { (error, reference) in
                    if error != nil {
                        print("There has been an error:\(error)")
                    }
                })
                
            })
            
//        Database.database().reference().child("groups").child(firstTree).child("users")[childIWantToRemove].removeValueWithCompletionBlock { (error, ref) in
//            if error != nil {
//                print("error \(error)")
//            }
//       }
    }


}
