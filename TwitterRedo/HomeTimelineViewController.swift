//
//  HomeTimelineViewController.swift
//  TwitterRedo
//
//  Created by Shaz Rajput on 8/6/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit
import AFNetworking

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tweetsTableView.dataSource = self
        self.tweetsTableView.delegate = self
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetsTableView.estimatedRowHeight = 150
        self.refreshTweets()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tweetsTableView.insertSubview(refreshControl, atIndex: 0)
       
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(_:)))
//        self.tweetsTableView.addGestureRecognizer(recognizer)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func onImageTap(recognizer: UIGestureRecognizer){
//        if recognizer.state == UIGestureRecognizerState.Ended {
//            let tapLocation = recognizer.locationInView(self.tweetsTableView)
//            if let tappedIndexPath = self.tweetsTableView.indexPathForRowAtPoint(tapLocation) {
//                if let tappedCell = self.tweetsTableView.cellForRowAtIndexPath(tappedIndexPath){
//                    print("tapped!!")
//                }
//            }
//        }
//    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.refreshTweets()
        refreshControl.endRefreshing()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets.count) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tweetsTableView.dequeueReusableCellWithIdentifier("TimelineViewTweetCell") as! TweetCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tweetsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.tweetsTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func refreshTweets(){
        
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            //print("num tweets received: \(self.tweets.count)")
            self.tweetsTableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
