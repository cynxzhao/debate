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
import SwiftyJSON

class News {
    var title: String
    var date: String
    var url: String
    var tags: [String]?
    var text: String?
    
    init(title: String, date: String, url: String)
    {
        self.title = title
        self.date = date
        self.url = url
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
        let title = dict["title"] as? String,
        let date = dict["date"] as? String,
        let url = dict["url"] as? String,
        let tags = dict["tags"] as? [String]
            else {return nil}
        
        self.title = title
        self.date = date
        self.url = url
        self.tags = tags
    }

    init(json: JSON) {
        self.title = json["webTitle"].stringValue
        self.date = json["webPublicationDate"].stringValue
        self.url = json["webUrl"].stringValue
        self.text = json["fields"]["bodyText"].stringValue
        
        }
}
