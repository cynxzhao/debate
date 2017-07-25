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

class News: Comparable {
    var title: String
    var date: String
    var url: String
    var tags: [String]?
    var date2: Date?
    var id: String?
    
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
    
    init?(snapshot1: DataSnapshot) {
        guard let dict = snapshot1.value as? [String : Any],
            let title = dict["title"] as? String,
            let date = dict["date"] as? String,
            let url = dict["url"] as? String,
            let id = dict["id"] as? String
            else {return nil}
        
        self.title = title
        self.date = date
        self.url = url
       self.id = id
    }

    init(guardianjson: JSON) {
        self.title = guardianjson["webTitle"].stringValue
        self.date = guardianjson["webPublicationDate"].stringValue
        self.url = guardianjson["webUrl"].stringValue
        }
    
    init(otherjson: JSON) {
        self.title = otherjson["title"].stringValue
        self.date = otherjson["publishedAt"].stringValue
        self.url = otherjson["url"].stringValue
    }
    
    init(nytjson: JSON) {
        self.title = nytjson["headline"]["main"].stringValue
        self.date = nytjson["pub_date"].stringValue
        self.url = nytjson["web_url"].stringValue
    }
    
    static func ==(lhs: News, rhs: News) -> Bool {
        return lhs.date2! == rhs.date2!
    }
    
    static func <(lhs: News, rhs: News) -> Bool {
        return lhs.date2! < rhs.date2!
    }
}
