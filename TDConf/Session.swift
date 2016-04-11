//
//  Session.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import Foundation
import CloudKit

let SESSION_RECORD_TYPE  = "Session"

class Session: CKRecord
{

    var title: String!{
        didSet{
            title = self["title"] as! String
        }
        willSet{
            
        }
    }
    var startDate: NSDate!{
        didSet{
            startDate = self["startDate"] as! NSDate
        }
    }
    var endDate: NSDate!{
        didSet{
            endDate = self["endDate"] as! NSDate
        }
    }
    var sessionDescription: String!{
        didSet{
            sessionDescription = self["description"] as! String
        }
    }
    var author: String!{
        didSet{
            author = self["author"] as! String
        }
    }
    
    
    class func getAll(){
        let query = CKQuery(recordType: SESSION_RECORD_TYPE, predicate: NSPredicate(value:true))
        query.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
            
        }
    }
    
}
