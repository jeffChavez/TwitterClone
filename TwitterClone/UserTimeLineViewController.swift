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

class UserTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var userTimeLinePhotoImageView : UIImageView!
    @IBOutlet weak var userTimeLineUsernameLabel : UILabel!
    @IBOutlet weak var userTimeLineView : UIView!
    
    var tweets : [Tweet]?
    var networkController: NetworkController!
    var refreshControl: UIRefreshControl!
    
    var screenname : String?
    var user : String?
    var photo : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        self.userTimeLineUsernameLabel.text = user
        self.userTimeLinePhotoImageView.image = photo
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        networkController.fetchUserTimeLine(screenname) { (errorDescription, tweets) -> (Void) in
            if errorDescription == nil {
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                //alert the user that somethign went wrong
            }
        }
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
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("TWEET_VC") as TweetViewController
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.selectedTweet = self.tweets?[indexPath.row]
    }
}