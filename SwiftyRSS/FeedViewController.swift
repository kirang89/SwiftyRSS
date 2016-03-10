//
//  FeedViewController.swift
//  
//
//  Created by Kiran Gangadharan on 08/03/16.
//
//

import UIKit
import RealmSwift
import SWXMLHash
import Alamofire

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedTableView: UITableView!
    
    var defaultSources = [
        ("Upvoted", "https://upvoted.com/feed/")
    ]
    
    var sources : Results<FeedURL>!
    var feed: [FeedItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFeedTableView()
        
        let realm = try! Realm()
        realm.refresh()
        
        let sourceList = getSources()
        if (sourceList.count == 0) {
            addDefaultSources()
        }
        
        fetchLocalFeed()
        
        if(self.feed.count == 0) {
            getFeed({ () -> Void in
                self.feedTableView.reloadData()
                return
            })
        } else {
            self.feedTableView.reloadData()
        }
    }
    
    func setupFeedTableView() {
        
        self.feedTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Add pull-to-refresh for table
        let refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
            
            return refreshControl
        }()
        
        self.feedTableView.addSubview(refreshControl)
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        getFeed({ () -> Void in
            self.feedTableView.reloadData()
            refreshControl.endRefreshing()
            return
        })
        
    }
    
    func addDefaultSources() {
        let realm = try! Realm()
        for src in self.defaultSources {
            let feedUrl = FeedURL()
            feedUrl.title = src.0
            feedUrl.url = src.1
            
            try! realm.write({ () -> Void in
                realm.add(feedUrl)
            })
        }
    }
    
    func fetchLocalFeed() {
        let realm = try! Realm()
        realm.refresh()
        
        for item in realm.objects(FeedItem) {
            self.feed.insert(item, atIndex: 0)
        }
    }
    
    func getSources() -> Results<FeedURL> {
        let realm = try! Realm()
        return realm.objects(FeedURL)
    }
    
    func getFeed(completion: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            self.sources = self.getSources()
            for source in self.sources {
                self.fetchXMLContent(source.url) { (xmldata) -> Void in
                    
                    var newFeedItems = [FeedItem]()
                    let realm = try! Realm()
                    
                    for item in xmldata["rss"]["channel"]["item"] {
                        let title = item["title"].element!.text!
                        let existingItem = realm.objects(FeedItem).filter("title = %@", title)
                        
                        if (existingItem.count == 0) {
                            let feedItem = FeedItem()
                            feedItem.title = title
                            feedItem.link = item["link"].element!.text!
                            feedItem.descr = item["description"].element!.text!
                            
                            newFeedItems.append(feedItem)
                            
                            try! realm.write({ () -> Void in
                                realm.add(feedItem)
                            })
                        }
                    }
                    
                    self.feed = newFeedItems + self.feed
                    
                    if (newFeedItems.count > 0) {
                        completion()
                    }
                }
            }
        }
    }
    
    func fetchXMLContent(url: String, completion: (XMLIndexer) -> ()) {
        Alamofire.request(.GET, url, encoding: .PropertyList(.XMLFormat_v1_0, 0)).responseString { (response) -> Void in
            
            let xmldata = SWXMLHash.parse(response.result.value! as String) as XMLIndexer
            
            completion(xmldata)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedItemCell", forIndexPath: indexPath) as UITableViewCell
        let item = self.feed[indexPath.row]
        
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel!.numberOfLines = 3
        cell.textLabel!.text = item.title
        
        cell.detailTextLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.detailTextLabel!.numberOfLines = 2
        cell.detailTextLabel!.text = item.descr
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleSegue" {
            if let destVC = segue.destinationViewController as? ArticleViewController {
                let item = self.feed[self.feedTableView.indexPathForSelectedRow!.row]
                destVC.url = item.link
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
