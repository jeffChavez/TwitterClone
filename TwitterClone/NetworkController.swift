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
    var tweets : [Tweet]?
    var tweet : Tweet?
    
    func fetchHomeTimeLine(completionHandler: (errorDescription: String?, tweets: [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

        //asynchronous call, gets it's own queue automatically via requestAccessToAccountsWithType
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error: NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    if error == nil {
                        switch httpResponse.statusCode {
                        case 200...299:
                            self.tweets = Tweet.parseHomeTimeLineJSONDataIntoTweets(data)
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
    
    func fetchTweet(tweet: Tweet, completionHandler: (errorDescription: String?, tweet: Tweet?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
          //asynchronous call, gets it's own queue automatically via requestAccessToAccountsWithType
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error: NSError!) -> Void in
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json?id=\(tweet.id)")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    if error == nil {
                        switch httpResponse.statusCode {
                        case 200...299:
                            self.tweet = Tweet.parseTweetJSONDataIntoTweet(data)
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                completionHandler(errorDescription: nil, tweet: self.tweet)
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

    
    init () {
        
    }
}