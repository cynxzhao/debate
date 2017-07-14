//
//  Group.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase.FIRDataSnapshot

class Group {
    let groupName: String
    var users: [String]
    let news = [News]()
    
    init(groupName: String, users: [String]) {
        self.groupName = groupName
        self.users = users
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
        let groupName = dict["groupName"] as? String,
        let users = dict["users"] as? [String]
            else {return nil}
        
        self.groupName = groupName
        self.users = users
    }
}
