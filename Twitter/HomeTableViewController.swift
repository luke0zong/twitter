//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Yaowei on 10/2/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    var currentCell: UITableViewCell!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        
        tableView.refreshControl = myRefreshControl
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Note: Need the tweet view to be fullscreen to trigger this
        super.viewDidAppear(animated)
        print("Home page appear!")
        self.loadTweets()
    }
    
    @objc func loadMoreTweets() {
        
        numberOfTweet = numberOfTweet + 10
        
        let APIUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: APIUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            // clean the array between loads
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // reload data
            self.tableView.reloadData()
            
            
        }, failure: { Error in
            print("Could not load tweets: ", Error)
        })
    }
    
    @objc func loadTweets() {
        
        numberOfTweet = 20
        
        let APIUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet]
        
        
        TwitterAPICaller.client?.getDictionariesRequest(url: APIUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            // clean the array between loads
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // reload data
            self.tableView.reloadData()
            
            //dismiss the refresh circle
            self.myRefreshControl.endRefreshing()
            
        }, failure: { Error in
            print("Could not load tweets: ", Error)
        })
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath:
                            IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        self.dismiss(animated: true, completion: nil)
        
        // reset user defaults
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        
        print("logout succeed!")
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = tweetArray[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        let UrlString = (user["profile_image_url_https"] as! String).replacingOccurrences(of: "normal", with: "bigger")
        let profileURL = URL(string: UrlString)
        
        print(profileURL!)
        
        let data = try? Data(contentsOf: profileURL!)
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
            // set image to round
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width / 2
            cell.profileImage.clipsToBounds = true
        }
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweet["text"] as? String
        
        cell.timeLabel.text = getRelativeTime(timeString: (tweet["created_at"] as? String)!)
        
        // Set fav for the tweet
        cell.setFavorited(tweet["favorited"] as! Bool)
        
        // set the tweetID
        cell.tweetID = tweet["id"] as! Int
        
        cell.setRetweeted(tweet["retweeted"] as! Bool)
        
        self.currentCell = cell
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onProfile))
        // Add gesture recognizer to the view
        cell.profileImage.addGestureRecognizer(recognizer)
        
        cell.profileImage.isUserInteractionEnabled = true
        
        return cell
        
    }
    
    func getRelativeTime(timeString: String) -> String{
        let time: Date
        let dateFormatter = DateFormatter()
        //"created_at": "Wed May 23 06:01:13 +0000 2007",
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        return time.timeAgoDisplay()
    }
    
    
    @objc func onProfile() {
        print("profile tapped!")
//        let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
//        self.present(controller!, animated: true, completion: nil)
        performSegue(withIdentifier: "showProfile", sender: self.currentCell)
            
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tweetArray.count
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let tweet = tweetArray[indexPath.row]
        
        print(tweet)
        
        // pass the tweet info to user profile view
        let profileViewController = segue.destination as! ProfileViewController
        profileViewController.user = (tweet["user"] as! NSDictionary)
    }
    
    
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            if secondsAgo == 1 || secondsAgo == 0 {
                return "\(secondsAgo) sec ago"}
            return "\(secondsAgo) secs ago"
            
        } else if secondsAgo < hour {
            if secondsAgo <= 60 {return "1 min ago"}
            return "\(secondsAgo / minute) mins ago"
            
        } else if secondsAgo < day {
            if secondsAgo <= 3600 {
                return "1 hr ago"}
            return "\(secondsAgo / hour) hrs ago"
            
        } else if secondsAgo < week {
            if secondsAgo < 3600*24*2 {
                return "1 day ago"}
            return "\(secondsAgo / day) days ago"
        }
        if secondsAgo < 3600*24*7*2 {
            return "1 week ago"}
        return "\(secondsAgo / week) weeks ago"
    }
}
