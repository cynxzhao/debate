//
//  PersonalArchivesTableViewController.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PersonalArchivesTableViewController: UITableViewController {
    
    var new : News?
    var news = [News]()
    
    var filteredNews = [News]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredNews = news.filter { new in
            return new.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        news = []
        let ref = Database.database().reference().child("news").child(User.current.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snap in snapshot {
                self.new = News(snapshot1: snap)
                self.news.append(self.new!)
                
            }
            for n in self.news {
                n.date2 = n.date.toDateTime2()
            }
            
            self.tableView.reloadData()
            
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //news = []
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredNews.count
        }
        
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalArchivesTableViewCell", for: indexPath) as! PersonalArchivesTableViewCell
        
        var new : News
        if searchController.isActive && searchController.searchBar.text != "" {
            new = filteredNews[indexPath.row]
        } else {
            new = news[indexPath.row]
            
        }
        
        cell.titleLabel.text = new.title
        cell.dateLabel.text = new.date2!.toString2(dateFormat: "dd-MMM-yyyy HH:mm:ss")
//        cell.urlLabel.text = new.url
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetail" {
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
                let detailedArchivesViewController = segue.destination as! DetailedArchivesViewController
                // 4
                detailedArchivesViewController.news = new
            }
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        var removed: News?
        
        if editingStyle == .delete {
            
            removed = news.remove(at: indexPath.row)
            
        }
        
        NewsService.deleteFromArchives(article: removed!.id!)
        tableView.reloadData()
    }
    
    
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

extension PersonalArchivesTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension String
{
    func toDateTime2() -> Date
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
    func toString2( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
