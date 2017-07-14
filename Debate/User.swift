//
//  Users.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase.FIRDataSnapshot

class User : NSObject {
    // Create a private static variable to hold our current user
    private static var _current: User?
    // Create a computed variable that only has a getter that can access the private _current variable
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    // MARK: - Properties
    
    let uid: String
    var username: String
    var name: String
    var aboutMe: String
    let email: String
    var groups: [String]?
    
    // MARK: - Init
    
    init(uid: String, username: String, name: String, aboutMe: String, email: String) {
        self.uid = uid
        self.username = username
        self.name = name
        self.aboutMe = aboutMe
        self.email = email
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String,
            let name = dict["name"] as? String,
            let aboutMe = dict["aboutMe"] as? String,
            let email = dict["email"] as? String,
            let groups = dict["groups"] as? [String]
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.name = name
        self.aboutMe = aboutMe
        self.email = email
        self.groups = groups
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String,
            let name = aDecoder.decodeObject(forKey: Constants.UserDefaults.name) as? String,
            let aboutMe = aDecoder.decodeObject(forKey: Constants.UserDefaults.aboutMe) as? String,
            let email = aDecoder.decodeObject(forKey: Constants.UserDefaults.email) as? String
            
            else { return nil }
        
        self.uid = uid
        self.username = username
        self.name = name
        self.aboutMe = aboutMe
        self.email = email

        super.init()
    }
    
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
        aCoder.encode(email, forKey: Constants.UserDefaults.email)
        aCoder.encode(name, forKey: Constants.UserDefaults.name)
        aCoder.encode(aboutMe, forKey: Constants.UserDefaults.aboutMe)
    }
}
