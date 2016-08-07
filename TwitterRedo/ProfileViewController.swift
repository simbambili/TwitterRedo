//
//  ProfileViewController.swift
//  TwitterRedo
//
//  Created by Shaz Rajput on 8/6/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userHeaderImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetsView: UIView!
    @IBOutlet weak var followingView: UIView!
    @IBOutlet weak var followersView: UIView!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var tweetsTableView: UITableView!

    var tweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (User.currentUser != nil){
            self.userProfileImage.setImageWithURL((User.currentUser!.profileUrl)!)
            self.userHeaderImage.setImageWithURL(User.currentUser!.bannerImageUrl!)
            self.blurImage(self.userHeaderImage)
            self.userProfileImage.layer.cornerRadius = 4
            self.userProfileImage.clipsToBounds = true
            self.userProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
            self.userProfileImage.layer.borderWidth = 2
            self.userNameLabel.text = String(User.currentUser!.name!)
            self.userScreenNameLabel.text = "@" + String(User.currentUser!.screename!)
            self.setBorder(self.tweetsView)
            self.setBorder(self.followingView)
            self.setBorder(self.followersView)
            self.numTweetsLabel.text = String(User.currentUser!.numTweets)
            self.numFollowingLabel.text = String(User.currentUser!.numFollowing)
            self.numFollowersLabel.text = String(User.currentUser!.numFollowers)
            
        }
        
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
        return (tweets.count) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tweetsTableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
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
    
    func blurImage(imageView: UIImageView){
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
    }
    
    func setBorder(view: UIView){
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
    }

}
