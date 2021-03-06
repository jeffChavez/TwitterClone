TwitterClone
============
Week 1 Assignment at Code Fellows<br><br>
This is a Twitter clone. Users can sign in with their twitter account and view their home timeline just like they would on the Twitter app. Upon selecting a tweet, the user is taken to  detailed view of that tweet. If the user taps on the profile image, they are taken to that user's timeline. The navigation is handled with push and pop methods, which allows the user to navigate as deep in the stack as the app's memory will allow.

![Imgur](https://github.com/jeffChavez/TwitterClone/blob/master/TwitterClone1.gif)

###Features
- singleton objects, for the `NetworkController` instance when making a call
- Lazy loading on profile images
- Push and pop navigation
- Dynamically resizing tableview cells
- Nib views
- Extensive interaction with Twitter's REST API
- `UIRefreshControl` to update timeline with latest tweets
- `ACAccount` & `ACAccountStore` for handling the twitter account
- `NSURLSession`
- `NSOperationQueue`
- JSON Parsing

###Assignment

Monday<br>
- Create groups in your project for the model, view, and controller layer of your app
- Successfully parse the provided JSON file into Tweet model objects
- Add a table view to your view controller, and have it display all of the tweets that you parsed from the JSON

Tuesday<br>
- Use the Accounts framework to get access to the user’s twitter account
- Use the social framework to fetch the users timeline
- Bake in status code checking into your network call and log out the status code
- Have your tableview display the user’s timeline once the network operation is completed back on the main thread
- Create a custom tableview cell class, and display the avatar image for each tweet in an image view on each cell

Wednesday<br>
- Create a network controller class that will be responsible for making all network calls to Twitter. The view controllers themselves should not be touching any URLS
- Create a second view controller called SingleTweetViewController that is devoted to just showing a single tweet, the user who tweeted it, and how many retweets and favorite it has. This view controller should be segued to when the user selects a cell from the home timeline.
- Move your image downloading to the network controller as well. 
- Using autolayout on your custom cell, achieve dynamic cell height.  Check out this blog post to get you started with this particular feature: http://www.appcoda.com/self-sizing-cells/ (Links to an external site.)

Thursday<br>
- Remove all Segues from your app, and instead use the push and pop methods on your navigation controller.
- Create a nib for your tweet cell, so we don't have to layout the same tableview cell in multiple spots.
- Create a third view controller that is devoted to showing a user’s most recent tweets. This should be pushed onto the navigation stack when the user clicks on the user’s picture in the single tweet view controller.
- Create a table view header view in your user timeline view controller. It should display the user's image and the user's name.
- Implement a Queue and Stack in a separate playground.

Friendship Friday

Pair programming rules:
- You must be working in a pair of 2 at all times. The best pairs have similar experience levels.
- One person will be typing (driving), but the other person needs to actively contribute. Each line of code you guys write should be discussed and decided upon. Keep an open mind, and if you guys disagree on something, try one way first and see if it works, if it doesn't try the other way.
- Don't physically harm your partner.
- Switch roles every half hour.
Remember to high-five when you guys do something awesome. See http://en.wikipedia.org/wiki/High_five (Links to an external site.) for more info on this ritual.
The friendship friday challenges can be submitted jointly, if the work you did is on a different person's project, please note that in your homework submission. If the feature(s) you guys built is so awesome you just have to have it in your own project, copy it over.

Challenges<br>
- Harness the power of the since_id parameter on your api calls. The since_id gives you tweets that are more recent than the id you pass in as the since_id. Combine this, with pull to refresh, to let the user refresh their timelines with the latest tweets.
- Use the max_id parameter. This is similar to since_id, except it gives you tweets older than the id provided as the max_id. So as the user scrolls towards the bottom of the table view, use the max_id to pull down more tweets. You can basically achieve infinite scrolling with this.
- Implement a tab bar controller, just like the actual twitter app. Implement at least one of the tabs, you can pick which one you want to implement.
- Implement an image cache. This cache should make it so you never download the same user image more than once while the app running. This cache can be completely in memory with no persistence. But persistence would be an extra challenge as well.
