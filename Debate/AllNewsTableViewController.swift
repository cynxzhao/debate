//
//  AllNewsTableViewController.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AllNewsTableViewController: UITableViewController {

    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        let category = ""
        
//        Alamofire.request("http://content.guardianapis.com/search?order-by=newest&show-fields=bodyText&q=\(category)&from-date=2017-07-17&api-key=426baee8-e5b2-45f3-b569-55c660e95afa").responseString { response in
//            //            print("Success: \(response.result.isSuccess)")
//            //            print("Response String: \(response.result.value)")
//            
//            let json = JSON(parseJSON: response.result.value!)
//            print(json["response"]["results"][0]["fields"]["bodyText"])
//        }
        
//        let year = 2017
//        let month = 7
        
//        Alamofire.request("http://api.nytimes.com/svc/archive/v1/\(year)/\(month).json?api-key=dc6e71fa3ac84b98a4276c8cf08661cc").responseString { response in
            
//            let json = JSON(parseJSON: response.result.value!)
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let url = URL(string: "http://content.guardianapis.com/search?order-by=newest&show-fields=bodyText&page-size=50&from-date=2017-07-18&api-key=426baee8-e5b2-45f3-b569-55c660e95afa")
                let contents = try! Data(contentsOf: url!)
                let newsData = JSON(data: contents)
        
                let allNewsData = newsData["response"]["results"].arrayValue
                for n in allNewsData {
                        let ne = News(json: n)
                        self.news.append(ne)
                        }
        
//                let currentNewsData = newsData["response"]["results"][0]
//                let currentNews = News(json: currentNewsData)
//                print(currentNews.title)
        
        
//        for index in 0...49 {
//            Alamofire.request("http://content.guardianapis.com/search?order-by=newest&page-size=50&q=&from-date=2017-07-17&api-key=426baee8-e5b2-45f3-b569-55c660e95afa").responseString { response in
//                //            print("Success: \(response.result.isSuccess)")
//                //            print("Response String: \(response.result.value)")
//                
//                let json = JSON(parseJSON: response.result.value!)
//                print(json["response"]["results"][index]["webTitle"])
////                NewsService.create(title: json["response"], source: , date: <#T##String#>, completion: <#T##(News?) -> Void#>)
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allNewsTableViewCell", for: indexPath) as! AllNewsTableViewCell
        
        // 1
        let row = indexPath.row
        
        // 2
        let new = news[row]
        
        cell.titleLabel.text = new.title
        cell.dateLabel.text = new.date
        cell.urlLabel.text = new.url
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetailedAllNews" {
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let new = news[indexPath.row]
                // 3
                let detailedAllNewsViewController = segue.destination as! DetailedAllNewsViewController
                // 4
                detailedAllNewsViewController.new = new
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
