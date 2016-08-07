//
//  TweetCell.swift
//  TwitterRedo
//
//  Created by Shaz Rajput on 8/7/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var tweetText: NSString?
    
    var tweet: Tweet! {
        didSet{
            self.profileImage.setImageWithURL(tweet.profileImageURL!)
            self.usernameLabel.text = tweet.userName!
            self.screenNameLabel.text = "@" + tweet.screenName!
            self.messageLabel.text = tweet.text!
            self.messageLabel.sizeToFit()
            self.timestampLabel.text = TimeAgo().timeAgoSince(tweet.timestamp!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if (self.profileImage != nil) {
            self.profileImage.layer.cornerRadius = 3
            self.profileImage.clipsToBounds = true
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
