//
//  SourceViewController.swift
//  SwiftyRSS
//
//  Created by Kiran Gangadharan on 09/03/16.
//  Copyright © 2016 kiran. All rights reserved.
//

import UIKit
import RealmSwift

class SourceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sources = [FeedURL]()

    
    @IBOutlet weak var sourceTableView: UITableView!
    
    
    @IBAction func feedButtonPressed(sender: AnyObject) {
        
        showFeedView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        for item in realm.objects(FeedURL) {
            sources.insert(item, atIndex: 0)
        }

        self.sourceTableView.reloadData()
    }
    
    func showFeedView() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sources.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sourceCell", forIndexPath: indexPath)
        
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel!.numberOfLines = 2
        cell.textLabel?.text = sources[indexPath.row].title
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
