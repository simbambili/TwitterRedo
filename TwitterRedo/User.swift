//
//  User.swift
//  TwitterRedo
//
//  Created by Shaz Rajput on 8/6/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screename: NSString?
    var profileUrl: NSURL?
    var bannerImageUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var numFollowers: Int
    var numFollowing: Int
    var numTweets: Int
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        self.name = dictionary["name"] as? String
        self.screename = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            self.profileUrl = NSURL(string: profileUrlString)
        }
        
        let bannerImageUrlString = dictionary["profile_banner_url"] as? String
        if let bannerImageUrlString = bannerImageUrlString {
            self.bannerImageUrl = NSURL(string: bannerImageUrlString)
        }
        
        self.tagline = dictionary["description"] as? String
        self.numFollowers = (dictionary["followers_count"] as? Int) ?? 0
        self.numFollowing = (dictionary["following"] as? Int) ?? 0
        self.numTweets = (dictionary["statuses_count"] as? Int) ?? 0
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                    
                }             }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
}
