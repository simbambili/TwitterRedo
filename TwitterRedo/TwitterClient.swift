//
//  TwitterClient.swift
//  TwitterRedo
//
//  Created by Shaz Rajput on 8/6/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "MYIb2O5lmB8RGKINou2IJow49", consumerSecret: "See1MFQ27Dc4AaKQ24aLo7qDdGs3wQXCiUWx0UZR0yUCtqXxml")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()){
        
        self.loginSuccess = success
        self.loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("/oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterRedo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) {(error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure!(error)
        }
        
    }
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        //print("in homeTimeLine function")
        GET("/1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {
            (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("home_timeline: \(response)")
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    
    func mentionsTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET("/1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: {
            (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("home_timeline: \(response)")
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        
        GET("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {
            (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("account: \(response)")
            let userDicitionary = response as! NSDictionary
            let user = User(dictionary: userDicitionary)
            success(user)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("I got the access token")
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            self.loginSuccess?()
            
        }) { (error: NSError!) -> Void in
            self.loginFailure?(error)
        }
    }
    
    func updateStatus(tweet: String, in_reply_to_status_id: String){
        var payload = ["status": tweet]
        if in_reply_to_status_id.characters.count > 0 {
            payload["in_reply_to_status_id"] = in_reply_to_status_id
        }
        POST("/1.1/statuses/update.json", parameters: payload, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Tweet response: \(response)")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
        })
    }
    
    func tweet(tweet: String, reply_to: String, success: () -> (), failure: (NSError) -> ()) {
        
        var payload = ["status": tweet]
        if (reply_to.characters.count > 0) {
            payload["in_reply_to_status_id"] = reply_to
        }
        
        POST("/1.1/statuses/update.json", parameters: payload, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print(response)
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
                failure(error)
        })
        
    }
}