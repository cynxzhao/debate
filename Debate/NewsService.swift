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

struct NewsService {
    static func create(title: String, source: String, date: String, completion: @escaping (News?) -> Void) {
        let newsAttr = ["title": title,
                         "source" : source,
                         "date" : date,
                         "tags": ["none"]] as [String : Any]
        
        let ref = Database.database().reference().child("news").childByAutoId()
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
    
}
