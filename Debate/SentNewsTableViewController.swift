//
//  SentNewsTableViewController.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SentNewsTableViewController: UITableViewController {

    
    var group : Group?
    var news = [News]()
    var filteredNews = [News]()
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ref = Database.database().reference().child("groups").child(group!.id).child("news")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snap in snapshot {
            let new = News(snapshot: snap)
            self.news.append(new!)

            }
            for n in self.news {
                n.date2 = n.date.toDateTime1()
            }
            self.news.reverse()
            self.tableView.reloadData()

        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        news = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        self.navigationItem.title = group!.groupName
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredNews = news.filter { new in
            
            var allTags = ""

            for n in new.tags ?? [] {
                allTags += "\(n) "
            }
            print(allTags)
            return allTags.lowercased().contains(searchText.lowercased())

            }
        
        filteredNews.reverse()
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredNews.count
        }
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentNewsTableViewCell", for: indexPath) as! SentNewsTableViewCell
        
        
        var new : News
        if searchController.isActive && searchController.searchBar.text != "" {
            new = filteredNews[indexPath.row]
        } else {
            new = news[indexPath.row]
        }
        
        cell.titleLabel.text = new.title
        cell.dateLabel.text = new.date2!.toString(dateFormat: "dd-MMM-yyyy HH:mm:ss")
        var allTags = ""
        for tag in new.tags ?? [] {
            allTags += "\(tag) "
        }
        cell.tagsLabel.text = allTags
        
        let ref = Database.database().reference().child("users").child(new.sender!).child("username")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            cell.senderLabel.text = snapshot.value as? String

        })
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toMembersList" {
                // 1
//                let indexPath = tableView.indexPathForSelectedRow!
                // 3
                let MembersTableViewController = segue.destination as! MembersTableViewController
                // 4
                MembersTableViewController.group = group
            }
        else if identifier == "toDetailedNews" {
                    // 1
                    let indexPath = tableView.indexPathForSelectedRow!
                    // 2
                let new: News
                if searchController.isActive && searchController.searchBar.text != "" {
                    new = filteredNews[indexPath.row]
                } else {
                    new = news[indexPath.row]
                }
                    // 3
                    let detailedNewsViewController = segue.destination as! DetailedNewsViewController
                    // 4
                    detailedNewsViewController.news = new
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

extension SentNewsTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension String
{
    func toDateTime1() -> Date
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
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
