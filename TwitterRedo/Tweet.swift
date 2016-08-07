//
//  Tweet.swift
//  TwitterRedo
//
//  Created by Shaz Rajput on 8/6/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var profileImageURL: NSURL?
    var username: String?
    
    init(dictionary: NSDictionary){
        
        if let userDictionary = dictionary["user"] as? NSDictionary{
            self.username = userDictionary["screen_name"] as? String
            let profileImageUrlString = userDictionary["profile_image_url_https"] as? String
            
            if let profileImageUrlString = profileImageUrlString {
                self.profileImageURL = NSURL(string: profileImageUrlString)
            }
            
        } else {
            self.username = "Anon"
        }
        
        
        self.text = dictionary["text"] as? String
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoriteCount = (dictionary["favourites_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            self.timestamp = formatter.dateFromString(timestampString)
            
        }
        
        
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
}