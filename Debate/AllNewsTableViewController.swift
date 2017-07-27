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
import MBProgressHUD

class AllNewsTableViewController: UITableViewController {
    
    
    var news = [News]()
//    let myRefreshControl = UIRefreshControl()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
//        myRefreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
//        tableView.addSubview(myRefreshControl)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
        MBProgressHUD.hide(for: self.view, animated: true)
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        // MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func reload() {
        news = []
        
        var GData, BData, AData, EData, WData, LData, HData, BBCData: [JSON]?
        
        let dispatchGroup = DispatchGroup()
        
        
        dispatchGroup.enter()
        Alamofire.request("https://newsapi.org/v1/articles?source=business-insider&sortBy=latest&apiKey=069c5469ce9a4cce87b2efb29a06bf90").responseJSON { response in
            let BnewsData = JSON(json: response.result.value!)
            BData = BnewsData["articles"].arrayValue
            
            for b in BData! {
                let bb = News(otherjson: b)
                self.news.append(bb)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        
        Alamofire.request("https://content.guardianapis.com/search?order-by=newest&page-size=50&from-date=2017-07-18&api-key=426baee8-e5b2-45f3-b569-55c660e95afa")
            .responseJSON { response in
                let GnewsData = JSON(json: response.result.value!)
                GData = GnewsData["response"]["results"].arrayValue
                
                for g in GData! {
                    let gg = News(guardianjson: g)
                    self.news.append(gg)
                }
                dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Alamofire.request("https://newsapi.org/v1/articles?source=associated-press&apiKey=069c5469ce9a4cce87b2efb29a06bf90").responseJSON { response in
            let AnewsData = JSON(json: response.result.value!)
            AData = AnewsData["articles"].arrayValue
            
            for a in AData! {
                let aa = News(otherjson: a)
                self.news.append(aa)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Alamofire.request("https://newsapi.org/v1/articles?source=the-economist&sortBy=latest&apiKey=069c5469ce9a4cce87b2efb29a06bf90").responseJSON { response in
            let EnewsData = JSON(json: response.result.value!)
            EData = EnewsData["articles"].arrayValue
            
            for e in EData! {
                let ee = News(otherjson: e)
                self.news.append(ee)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Alamofire.request("https://newsapi.org/v1/articles?source=the-washington-post&apiKey=069c5469ce9a4cce87b2efb29a06bf90").responseJSON { response in
            let WnewsData = JSON(json: response.result.value!)
            WData = WnewsData["articles"].arrayValue
            
            for w in WData! {
                let ww = News(otherjson: w)
                self.news.append(ww)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Alamofire.request("https://newsapi.org/v1/articles?source=the-wall-street-journal&apiKey=069c5469ce9a4cce87b2efb29a06bf90").responseJSON { response in
            let LnewsData = JSON(json: response.result.value!)
            LData = LnewsData["articles"].arrayValue
            
            for l in LData! {
                let ll = News(otherjson: l)
                self.news.append(ll)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Alamofire.request("https://newsapi.org/v1/articles?source=the-huffington-post&apiKey=069c5469ce9a4cce87b2efb29a06bf90").responseJSON { response in
            let HnewsData = JSON(json: response.result.value!)
            HData = HnewsData["articles"].arrayValue
            
            for h in HData! {
                let hh = News(otherjson: h)
                self.news.append(hh)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Alamofire.request("https://newsapi.org/v1/articles?source=bbc-news&apiKey=069c5469ce9a4cce87b2efb29a06bf90").responseJSON { response in
            let BBCnewsData = JSON(json: response.result.value!)
            BBCData = BBCnewsData["articles"].arrayValue
            
            for bbc in BBCData! {
                let bbcc = News(otherjson: bbc)
                self.news.append(bbcc)
            }
            dispatchGroup.leave()
        }
        
        
        /*        let Gcontents = try! Data(contentsOf: Guardianurl!)
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
         let BBCData = BBCnewsData["articles"].arrayValue */
        
        
        /*       for g in GData! {
         let gg = News(guardianjson: g)
         news.append(gg)
         }
         
         for b in BData! {
         let bb = News(otherjson: b)
         news.append(bb)
         }
         
         for a in AData! {
         let aa = News(otherjson: a)
         self.news.append(aa)
         }
         
         //        for c in CData {
         //            let cc = News(otherjson: c)
         //            self.news.append(cc)
         //        }
         
         for e in EData! {
         let ee = News(otherjson: e)
         self.news.append(ee)
         }
         
         
         for w in WData! {
         let ww = News(otherjson: w)
         self.news.append(ww)
         }
         
         for l in LData! {
         let ll = News(otherjson: l)
         self.news.append(ll)
         }
         
         for h in HData! {
         let hh = News(otherjson: h)
         self.news.append(hh)
         }
         
         for bbc in BBCData! {
         let bbcc = News(otherjson: bbc)
         self.news.append(bbcc)
         } */
        
        
/*        var x = 0
        
        for n in self.news {
            if n.date == "" {
                var removed = news.remove(at: x)
            } else {
                n.date2 = n.date.toDateTime()
                x += 1
            }
        }
        self.news = self.news.sorted(by: >) */
        
//        if self.myRefreshControl.isRefreshing {
//            self.myRefreshControl.endRefreshing()
//        }
        
        dispatchGroup.notify(queue: .main, execute: {
            var x = 0
            
            for n in self.news {
                if n.date.characters.count != 20 {
                    self.news.remove(at: x)
                } else {
                    n.date2 = n.date.toDateTime()
                    x += 1
                }
            }
            self.news = self.news.sorted(by: >)
            self.tableView.reloadData()
        })
        
        
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
        cell.dateLabel.text = new.date2!.toString1(dateFormat: "dd-MMM-yyyy HH:mm:ss")
//        cell.urlLabel.text = new.url
        
        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //news = []
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
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
    
}

extension Date
{
    func toString1( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
