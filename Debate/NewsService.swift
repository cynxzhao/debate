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
    static func create(group: Group, title: String, date: String, url: String, tags: [String], completion: @escaping (News?) -> Void) {
        let newsAttr = ["title": title,
                        "date": date,
                        "url" : url,
                        "tags": tags] as [String : Any]

        
    let ref = Database.database().reference().child("groups").child(group.id).child("news").childByAutoId()
        ref.updateChildValues(newsAttr) { (error, ref) in
            
            
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
    
    static func save(userID: String, title: String, date: String, url: String, completion: @escaping (News?) -> Void) {
        let newsAttr = ["title": title,
                        "date" : date,
                        "url": url] as [String: Any]
        
        let ref = Database.database().reference().child("news").child(userID).childByAutoId()
        
        ref.setValue(newsAttr) { (error, ref1) in
            if let error = error {
                print("THERE IS AN ERROR")
                assertionFailure(error.localizedDescription)
                return completion(nil)
            } else {
                let newsAttr2 = ["title" : title,
                                  "date": date,
                                  "url" : url,
                                  "id" : ref1.key] as [String : Any]
                //let ref2 = Database.database().reference().child("news").child(userID).child(ref.key)
                ref1.setValue(newsAttr2)
                ref1.observeSingleEvent(of: .value, with: { (snapshot) in
                    let news = News(snapshot1: snapshot)
                    completion(news)
                })
            }
            

        }
    }
    
    static func deleteFromArchives(article: String, completion: @escaping (News?) -> Void) {
        
        Database.database().reference().child("news").child(User.current.uid).child(article).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
            
        }
    }
}
