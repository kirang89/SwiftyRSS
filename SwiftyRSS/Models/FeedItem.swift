//
//  FeedItem.swift
//  SwiftyRSS
//
//  Created by Kiran Gangadharan on 08/03/16.
//  Copyright © 2016 kiran. All rights reserved.
//

import Foundation
import RealmSwift

class FeedItem: Object {
    
    dynamic var title = ""
    dynamic var link = ""
    dynamic var descr = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
