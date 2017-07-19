//
//  NewsService.swift
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
import Alamofire
import SwiftyJSON

struct NewsService {
    static func create(title: String, date: String, url: String, completion: @escaping (News?) -> Void) {
        let newsAttr = ["title" : title,
                        "date" : date,
                         "tags": ["none"]] as [String : Any]
        
        let ref = Database.database().reference().child("news").child(User.current.uid).child(url)
        ref.setValue(newsAttr) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let news = News(snapshot: snapshot)
                completion(news)
            })
        }

    }
    
    static func addTag(url: String, tags: [String], completion: @escaping (News?) -> Void) {
        let attr = ["tags": tags]
        
        let ref = Database.database().reference().child("news").child(User.current.uid).child(url)
        ref.updateChildValues(attr) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let news = News(snapshot: snapshot)
                completion(news)
            })
        }
    }
    
}
