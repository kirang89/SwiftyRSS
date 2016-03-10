//
//  ArticleViewController.swift
//  SwiftyRSS
//
//  Created by Kiran Gangadharan on 09/03/16.
//  Copyright © 2016 kiran. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url: String?
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if url != nil {
            let request = NSMutableURLRequest(URL: NSURL (string: url!)!)
            // Set mobile user agent to render mobile website correctly
            request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 9_0 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13A344 Safari/601.1", forHTTPHeaderField: "User-Agent")
            
            self.webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
