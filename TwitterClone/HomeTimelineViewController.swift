//
//  HomeTimelineViewController.swift
//  TwitterClone
//
//  Created by Jeff Chavez on 10/6/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    
    var tweets : [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
            var error : NSError?
            let jsonData = NSData(contentsOfFile: path)
            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tweets!.sort {$0.text > $1.text}
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as UITableViewCell
        // figure out which model object you are hoing to use to configure the cell
        let tweet = self.tweets?[indexPath.row]
        cell.textLabel?.text = tweet?.text
        //return the cell
        return cell
    }
}