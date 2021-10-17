//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Yaowei on 10/2/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited: Bool = false
    var tweetID: Int = -1
    var retweeted: Bool = false
    
    func setFavorited(_ isFav:Bool) {
        favorited = isFav
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool) {
        if isRetweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
        
    }
    
    @IBAction func favClicked(_ sender: Any) {
        let fav = !favorited
        if (fav) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetID, success: {
                self.setFavorited(true)
            }, failure: { Error in
                print("Error to fav: \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetID, success: {
                self.setFavorited(false)
            }, failure: { Error in
                print("Error to unfav: \(Error)")
            })
        }
    }
    
    @IBAction func retweetClicked(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetID, success: {
            self.setRetweeted(true)
        }, failure: { Error in
            print("Error to retweet: \(Error)")
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
