//
//  AddItemViewController.swift
//  SwiftyRSS
//
//  Created by Kiran Gangadharan on 08/03/16.
//  Copyright © 2016 kiran. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import RealmSwift

class AddItemViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func addButtonPressed(sender: UIButton) {
        
        let url = urlTextField.text! as String
        if (url.isEmpty == false) {
            
            activityIndicator.startAnimating()
            
            fetchXMLContent(url) { (xmldata) -> Void in
                
                self.saveURLWithData(url, data: xmldata) { () -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    self.showFeedView()
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        self.showFeedView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        setupUrlTextField()
        
        let btnLayer = self.addButton.layer as CALayer
        btnLayer.masksToBounds = true
        btnLayer.cornerRadius = 5.0
        btnLayer.borderWidth = 1.0
        btnLayer.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    func setupUrlTextField() {
        
        urlTextField.text = ""
        urlTextField.borderStyle = UITextBorderStyle.None
        urlTextField.layer.cornerRadius = 4.0
        urlTextField.layer.masksToBounds = true
        urlTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        urlTextField.layer.borderWidth = 1.0
        
        let paddingView =  UIView(frame: CGRectMake(0, 0, 10, 20))
        urlTextField.leftView = paddingView;
        urlTextField.leftViewMode = UITextFieldViewMode.Always;
        
    }
    
    func dismissKeyboard() {
        
        self.urlTextField.resignFirstResponder()
        
    }

    func fetchXMLContent(url: String, completion: (XMLIndexer) -> ()) {
        Alamofire.request(.GET, url, encoding: .PropertyList(.XMLFormat_v1_0, 0)).responseString { (response) -> Void in
            
            let xmldata = SWXMLHash.lazy(response.result.value! as String)
            
            completion(xmldata)
        }
    }
    
    func saveURLWithData(url: String, data: XMLIndexer, completion: () -> ()) {
        let feedurl = FeedURL()
        feedurl.title = data["rss"]["channel"]["title"].element!.text!
        feedurl.url = url
        
        let realm = try! Realm()
        try! realm.write({ () -> Void in
            realm.add(feedurl)
            completion()
        })
    }
    
    func showFeedView() {
        self.dismissViewControllerAnimated(true, completion: nil)
//        let feedVC = self.storyboard?.instantiateViewControllerWithIdentifier("feedViewController") as! FeedViewController
//        presentViewController(feedVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
