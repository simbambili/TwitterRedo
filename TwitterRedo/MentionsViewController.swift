//
//  MentionsViewController.swift
//  TwitterRedo
//
//  Created by Shaz Rajput on 8/6/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mentionsTableView: UITableView!
    @IBOutlet weak var noMentionsView: UIView!

    var mentions = [Tweet]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.noMentionsView.hidden = true
        self.mentionsTableView.dataSource = self
        self.mentionsTableView.delegate = self
        self.mentionsTableView.rowHeight = UITableViewAutomaticDimension
        self.mentionsTableView.estimatedRowHeight = 150
        self.refreshTweets()
        
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.mentionsTableView.insertSubview(refreshControl, atIndex: 0)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.refreshTweets()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.mentions.count) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.mentionsTableView.dequeueReusableCellWithIdentifier("MentionsCell") as! TweetCell
        cell.tweet = self.mentions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.mentionsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.mentionsTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func refreshTweets(){
        self.noMentionsView.hidden = true
        
        TwitterClient.sharedInstance.mentionsTimeLine({ (tweets: [Tweet]) -> () in
            self.mentions = tweets
            if (self.mentions.count > 0){
                self.mentionsTableView.reloadData()
            } else {
                self.noMentionsView.hidden = false
            }
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
}
