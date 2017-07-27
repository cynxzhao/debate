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
    
            
//        Database.database().reference().child("groups").child(firstTree).child("users")[childIWantToRemove].removeValueWithCompletionBlock { (error, ref) in
//            if error != nil {
//                print("error \(error)")
//            }
//       }


    static func leave(groupID: String, username: String) {
        
        var allGroups = [String]()
        let ref1 = Database.database().reference().child("users").child(User.current.uid).child("groups")
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snap in snapshot {
                allGroups.append((snap.value as? String)!)
            }
            
            var index = allGroups.index(of: groupID)
            allGroups.remove(at: index!)
            ref1.setValue(allGroups)
            
            if allGroups == [] {
                allGroups.append("abc")
                ref1.setValue(allGroups)
            }
            
            //            NotificationCenter.default.post(name: Notification.Name(rawValue: "left"), object: self)
            
        })
        
        var allUsers = [String]()
        let ref = Database.database().reference().child("groups").child(groupID).child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snap in snapshot {
                allUsers.append((snap.value as? String)!)
            }
            
        var index = allUsers.index(of: username)
        allUsers.remove(at: index!)
            ref.setValue(allUsers)

            if allUsers == [] {
              Database.database().reference().child("groups").child(groupID).removeValue()
            }
        })
    }
    
    static func updateUsername(new: String, completion: @escaping (Int?) -> Void) {
        let oldName = User.current.username
        let ref2 = Database.database().reference().child("users").child(User.current.uid).child("groups")
        ref2.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for group in snapshot {
                
                if group.value as? String != "abc" {
                let ref3 = Database.database().reference().child("groups").child((group.value as? String)!).child("users")
                ref3.observeSingleEvent(of: .value, with: { (users) in
                    guard var users = users.children.allObjects as? [DataSnapshot]
                        else {return}
                    var allUsers = [String]()
                    for user in users {
                        allUsers.append((user.value as? String)!)
                    }
                    var index = allUsers.index(of: oldName)
                    allUsers[index!] = new
                    ref3.setValue(allUsers)
                    completion(index)
                })
                }
            }
        })
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
}
