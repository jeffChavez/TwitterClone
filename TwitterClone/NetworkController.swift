//
//  NetworkController.swift
//  TwitterClone
//
//  Created by Jeff Chavez on 10/8/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkController {
    
    var twitterAccount : ACAccount?
    let imageQueue = NSOperationQueue()
    var tweets : [Tweet]?
    var tweet : Tweet?
    
    func fetchHomeTimeLine(since_id: String?, completionHandler: (errorDescription: String?, tweets: [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

        //asynchronous call, gets it's own queue automatically via requestAccessToAccountsWithType
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error: NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                var twitterRequest : SLRequest!
                
                if since_id == nil {
                    twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                } else {
                    twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: ["since_id": since_id!])
                }
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    if error == nil {
                        switch httpResponse.statusCode {
                        case 200...299:
                            self.tweets = Tweet.parseTimeLineJSONDataIntoTweets(data)
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                completionHandler(errorDescription: nil, tweets: self.tweets)
                            })
                        case 400...499:
                            println("this is the client's fault")
                        case 500...599:
                            println("this is the server's fault")
                        default:
                            println("something bad happened")
                        }
                    } else {
                        println("twitterRequest.performRequestWithHandler received an error")
                    }
                })
            }
        }
    }

    func fetchUserTimeLine(userScreenname: String?, completionHandler: (errorDescription: String?, tweets: [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        //asynchronous call, gets it's own queue automatically
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error: NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")
                let parameters = ["screen_name": userScreenname!]
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: parameters)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    if error == nil {
                        switch httpResponse.statusCode {
                        case 200...299:
                            self.tweets = Tweet.parseTimeLineJSONDataIntoTweets(data)
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                completionHandler(errorDescription: nil, tweets: self.tweets)
                            })
                        case 400...499:
                            println("this is the client's fault")
                        case 500...599:
                            println("this is the server's fault")
                        default:
                            println("something bad happened")
                        }
                    } else {
                        println("twitterRequest.performRequestWithHandler received an error")
                    }
                })
            }
        }
    }
    
    func downloadUserImageForTweet(tweet: Tweet, completionHandler: (image: UIImage) -> (Void)) {
        self.imageQueue.addOperationWithBlock { () -> Void in
            let url = NSURL(string: tweet.photoURLString)
            let imageData = NSData(contentsOfURL: url!)
            let photo = UIImage(data:imageData!)
            tweet.photo = photo
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(image: photo!)
            })
        }
    }

    init () {
        
    }
}