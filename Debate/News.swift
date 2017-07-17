//
//  News.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase.FIRDataSnapshot


class News {
    var title: String
    var source: String
    var date: String
    var tags: [String]?
    
    init(title: String, source: String, date: String)
    {
        self.title = title
        self.source = source
        self.date = date
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
        let title = dict["title"] as? String,
        let source = dict["source"] as? String,
        let date = dict["date"] as? String,
        let tags = dict["tags"] as? [String]
            else {return nil}
        
        self.title = title
        self.source = source
        self.date = date
        self.tags = tags
    }

}
