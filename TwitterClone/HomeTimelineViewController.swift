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

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    
    var tweets : [Tweet]?
    var networkController: NetworkController!
    var refreshControl : UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        networkController.fetchHomeTimeLine (nil) { (errorDescription, tweets) -> (Void) in
            if errorDescription == nil {
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                //alert the user that somethign went wrong
            }

        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tableView.reloadData()
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
        // figure out which model object you are going to use to configure the cell
        let tweet = self.tweets?[indexPath.row]
        cell.tweetLabel.text = tweet?.text
        cell.usernameLabel.text = tweet?.user
        cell.screennameLabel.text = tweet?.screenname
        
        if tweet?.photo != nil {
            cell.photoImageView.image = tweet?.photo
        } else {
            self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> (Void) in
                let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as CustomTableViewCell?
                cellForImage?.photoImageView.image = image
                cell.photoImageView.layer.cornerRadius = 3
                cell.photoImageView.layer.masksToBounds = true
                cell.photoImageView.layer.borderWidth = 0.5
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("TWEET_VC") as TweetViewController
        newVC.selectedTweet = self.tweets?[indexPath.row]
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func refresh (sender: AnyObject) {
        let tweetid = self.tweets?[0].id
        self.networkController.fetchHomeTimeLine (tweetid) { (errorDescription, tweets) -> (Void) in
            if errorDescription == nil {
                //alert the user something went wrong
                self.refreshControl?.endRefreshing()
            } else {
                var tweetsNew : [Tweet]? = tweets
                self.tweets! += tweetsNew!
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }

}