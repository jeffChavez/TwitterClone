//
//  HomeTimelineViewController.swift
//  TwitterClone
//
//  Created by Jeff Chavez on 10/6/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit
import Accounts
import Social

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    
    var tweets : [Tweet]?
    var twitterAccount : ACAccount?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
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
                    switch httpResponse.statusCode {
                    case 200...299:
                        self.tweets = Tweet.parseJSONDataIntoTweets(data)
                        //right here we are on a background queue aka thread
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.tableView.reloadData()
                            self.tableView.rowHeight = UITableViewAutomaticDimension
                        })
                    case 400...499:
                        println("this is the client's fault")
                    case 500...599:
                        println("this is the server's fault")
                    default:
                        println("something bad happened")
                    }
                })
            }
        }
        
//        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
//            var error : NSError?
//            let jsonData = NSData(contentsOfFile: path)
//            tweets = Tweet.parseJSONDataIntoTweets(jsonData)
//        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //dequeue cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as CustomTableViewCell
        // figure out which model object you are hoing to use to configure the cell
        let tweet = self.tweets?[indexPath.row]
        cell.tweetLabel.text = tweet?.text
        cell.photoImageView.image = tweet?.photo
        cell.usernameLabel.text = tweet?.user
        cell.screennameLabel.text = tweet?.screenname
        return cell
    }
}