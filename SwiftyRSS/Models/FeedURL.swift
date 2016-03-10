//
//  FeedURL.swift
//  SwiftyRSS
//
//  Created by Kiran Gangadharan on 08/03/16.
//  Copyright © 2016 kiran. All rights reserved.
//

import Foundation
import RealmSwift

class FeedURL: Object {
    
    dynamic var url = ""
    dynamic var title = ""
    dynamic var createdAt = NSDate()
    
    override static func primaryKey() -> String? {
        return "url"
    }

}
