//
//  TweetViewController.swift
//  TwitterClone
//
//  Created by Jeff Chavez on 10/8/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var screennameLabel : UILabel!
    @IBOutlet var photoImageView : UIImageView!
    @IBOutlet var tweetLabel : UILabel!
    @IBOutlet var favoriteLabel: UILabel!
    @IBOutlet var favoriteNumberLabel: UILabel!
    @IBOutlet var retweetLabel: UILabel!
    @IBOutlet var retweetNumberLabel: UILabel!
    
    var selectedTweet : Tweet?
    var networkController : NetworkController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = self.selectedTweet?.user
        screennameLabel.text = self.selectedTweet?.screenname
        photoImageView.image = self.selectedTweet?.photo
        tweetLabel.text = self.selectedTweet?.text
        retweetNumberLabel.text = self.selectedTweet?.retweets.description
        favoriteNumberLabel.text = self.selectedTweet?.favorites.description
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        self.networkController.fetchTweet(selectedTweet!, completionHandler: { (errorDescription: String?, tweet: Tweet?) -> (Void) in
            if errorDescription != nil {
                self.selectedTweet? = tweet!
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
