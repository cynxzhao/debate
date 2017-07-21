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
    
    let Guardianurl = URL(string: "http://content.guardianapis.com/search?order-by=newest&page-size=50&from-date=2017-07-18&api-key=426baee8-e5b2-45f3-b569-55c660e95afa")
    
    //    let NYTurl = URL(string: "http://api.nytimes.com/svc/archive/v1/2017/7.json?api-key=dc6e71fa3ac84b98a4276c8cf08661cc")
    
    let Businessurl = URL(string: "https://newsapi.org/v1/articles?source=business-insider&sortBy=latest&apiKey=069c5469ce9a4cce87b2efb29a06bf90")
    let APurl = URL(string: "https://newsapi.org/v1/articles?source=associated-press&apiKey=069c5469ce9a4cce87b2efb29a06bf90")
    //    let CNNurl = URL(string: "https://newsapi.org/v1/articles?source=cnn&apiKey=069c5469ce9a4cce87b2efb29a06bf90")
    let Econurl = URL(string: "https://newsapi.org/v1/articles?source=the-economist&sortBy=latest&apiKey=069c5469ce9a4cce87b2efb29a06bf90")
    let Washurl = URL(string: "https://newsapi.org/v1/articles?source=the-washington-post&apiKey=069c5469ce9a4cce87b2efb29a06bf90")
    let Wallurl = URL(string: "https://newsapi.org/v1/articles?source=the-wall-street-journal&apiKey=069c5469ce9a4cce87b2efb29a06bf90")
    let Huffurl = URL(string: "https://newsapi.org/v1/articles?source=the-huffington-post&apiKey=069c5469ce9a4cce87b2efb29a06bf90")
    let BBCurl = URL(string: "https://newsapi.org/v1/articles?source=bbc-news&apiKey=069c5469ce9a4cce87b2efb29a06bf90")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
                // guardian stuff
                let Gcontents = try! Data(contentsOf: Guardianurl!)
                let GnewsData = JSON(data: Gcontents)
                let GData = GnewsData["response"]["results"].arrayValue
                
                //new york times stuff
                //        let Ncontents = try! Data(contentsOf: NYTurl!)
                //        let NnewsData = JSON(data: Ncontents)
                //        var NData = [JSON]()
                //        for index in 0...39 {
                //        var n = NnewsData["response"]["docs"][index]
                //            NData.append(n)
                //        }
                
                //other stuff
                let Bcontents = try! Data(contentsOf: Businessurl!)
                let BnewsData = JSON(data: Bcontents)
                let BData = BnewsData["articles"].arrayValue
                
                let Acontents = try! Data(contentsOf: APurl!)
                let AnewsData = JSON(data: Acontents)
                let AData = AnewsData["articles"].arrayValue
                
                //        let Ccontents = try! Data(contentsOf: CNNurl!)
                //        let CnewsData = JSON(data: Ccontents)
                //        let CData = CnewsData["articles"].arrayValue
                
                let Econtents = try! Data(contentsOf: Econurl!)
                let EnewsData = JSON(data: Econtents)
                let EData = EnewsData["articles"].arrayValue
                
                let Wcontents = try! Data(contentsOf: Washurl!)
                let WnewsData = JSON(data: Wcontents)
                let WData = WnewsData["articles"].arrayValue
                
                let Lcontents = try! Data(contentsOf: Wallurl!)
                let LnewsData = JSON(data: Lcontents)
                let LData = LnewsData["articles"].arrayValue
                
                let Hcontents = try! Data(contentsOf: Huffurl!)
                let HnewsData = JSON(data: Hcontents)
                let HData = HnewsData["articles"].arrayValue
                
                let BBCcontents = try! Data(contentsOf: BBCurl!)
                let BBCnewsData = JSON(data: BBCcontents)
                let BBCData = BBCnewsData["articles"].arrayValue
                
                
                for g in GData {
                    let gg = News(guardianjson: g)
                    news.append(gg)
                }
                
                for b in BData {
                    let bb = News(otherjson: b)
                    news.append(bb)
                }
                
                for a in AData {
                    let aa = News(otherjson: a)
                    self.news.append(aa)
                }
                
                //        for c in CData {
                //            let cc = News(otherjson: c)
                //            self.news.append(cc)
                //        }
                
                for e in EData {
                    let ee = News(otherjson: e)
                    self.news.append(ee)
                }
                
                
                for w in WData {
                    let ww = News(otherjson: w)
                    self.news.append(ww)
                }
                
                for l in LData {
                    let ll = News(otherjson: l)
                    self.news.append(ll)
                }
                
                for h in HData {
                    let hh = News(otherjson: h)
                    self.news.append(hh)
                }
                
                for bbc in BBCData {
                    let bbcc = News(otherjson: bbc)
                    self.news.append(bbcc)
                }
                
                //        for nyt in NData {
                //            let nytt = News(nytjson: nyt)
                //            self.news.append(nytt)
                //        }
                var x = 0
                
                for n in self.news {
                    if n.date == "" {
                        var removed = news.remove(at: x)
                    } else {
                        n.date2 = n.date.toDateTime()
                        x += 1
                    }
                }
        self.news = self.news.sorted(by: >)
        tableView.reloadData()
            }
    
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        news = []
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
                detailedAllNewsViewController.news = new
            }
        }
    }
    
    @IBAction func unwindToAllNewsTableViewController(_ segue: UIStoryboardSegue) {
        
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

extension String
{
    func toDateTime() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)! as Date
        
        //Return Parsed Date
        return dateFromString
    }
    
//    func toDateNYT() -> Date
//    {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'+'SSSS'Z'"
//    
//        let dateFromString : Date = dateFormatter.date(from: self)! as Date
//        return dateFromString
//
//    }
}
