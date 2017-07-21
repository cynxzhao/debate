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
    
}
