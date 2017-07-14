//
//  GroupService.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct GroupService {
    
    static var allGroupIDs = [String]()
    
    static func create(_ firUser: FIRUser, groupName: String, users: [String], completion: @escaping (User?) -> Void) {

        var userAttrs = ["groups" : allGroupIDs]
        let userAttrs2 = ["groupName" : groupName,
                          "users" : users] as [String : Any]

        
        // the one in "groups"
        let ref2 = Database.database().reference().child("groups").childByAutoId()
        ref2.setValue(userAttrs2) { (error, ref1) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            let ref3 = Database.database().reference().child("users").child(firUser.uid)
            ref3.observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = User(snapshot: snapshot) {
                    var oldGroup = user.groups
                    if(oldGroup![0] == "abc") {
                        var newArray = [String]()
                        newArray.append(ref1.key)
                        userAttrs = ["groups" : newArray]
                        ref3.updateChildValues(userAttrs as [String: Any], withCompletionBlock: { (error, ref) in
                            if error == nil {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "uploaded"), object: self)

                            }
                        })
                    } else {
                        oldGroup!.append(ref1.key)
                        userAttrs = ["groups" : oldGroup!]
                        ref3.updateChildValues(userAttrs as [String: Any], withCompletionBlock: { (error, ref) in
                            if error == nil {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "uploaded"), object: self)
                                
                            }
                        })
                    }
                    
                }
                
            })
            
        }
        
    }
    
    static func show(groupID: String, completion: @escaping (Group?) -> Void) {
        let ref = Database.database().reference().child("groups").child(groupID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let group = Group(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(group)
        })
    }
    
    
}
