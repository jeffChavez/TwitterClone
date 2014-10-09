//
//  Tweet.swift
//  TwitterClone
//
//  Created by Jeff Chavez on 10/6/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import Foundation
import UIKit

class Tweet {
    
    var text : String
    var photo : UIImage
    var user : String
    var screenname : String
    var favorites : Int
    var retweets : Int
    var id : Int
    
    init (tweetInfo: NSDictionary) {
        let user = tweetInfo["user"] as NSDictionary
        self.text = tweetInfo["text"] as String
        let profileimageURLString = user["profile_image_url"] as String
        let profileimageURL = NSURL(string:profileimageURLString)
        self.photo = UIImage(data: NSData(contentsOfURL: profileimageURL), scale: UIScreen.mainScreen().scale)
        self.user = user["name"] as String
        let screennameString = user["screen_name"] as String
        self.screenname = "@\(screennameString)"
        self.retweets = tweetInfo["retweet_count"] as Int
        self.favorites = tweetInfo["favorite_count"] as Int
        self.id = tweetInfo["id"] as Int
    }
    
    class func parseHomeTimeLineJSONDataIntoTweets (rawJSONData: NSData) -> [Tweet]? {
        var error : NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            var tweets = [Tweet]()
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetInfo: tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            return tweets
        }
        return nil
    }
    
    class func parseTweetJSONDataIntoTweet (rawJSONData: NSData) -> Tweet? {
        var error : NSError?
        if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            
            var tweet : Tweet?
            var newTweet = Tweet(tweetInfo: JSONDictionary)
            return newTweet
        }
        return nil
    }

}