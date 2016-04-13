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
    var title: String!
    var startDate: NSDate!
    var endDate: NSDate!
    var sessionDescription: String!
    var author: String!

    convenience init(record: CKRecord)
    {
        self.init(recordType: SESSION_RECORD_TYPE)
        self.title = record["title"] as! String
        self.startDate = record["startDate"] as! NSDate
        self.endDate = record["endDate"] as! NSDate
        self.author = record["author"] as! String
        self.sessionDescription = record["description"] as! String
    }
    
    class func fetchAll(completion:(result:[Session]?, error: NSError?) -> Void)
    {
        let predicate = NSPredicate(value:true)
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        let queryOperation = KBQueryOperation(recordType: SESSION_RECORD_TYPE, predicate: predicate, resultLimit: nil, sort: sortDescriptor)
        queryOperation.performQuery { (result, error) in
            if error == nil
            {
                let sessions = result?.map({ (record) -> Session in
                    return Session(record: record)
                })
                completion(result: sessions, error: nil)
            }
            else
            {
                completion(result: nil, error: error)
            }
        }
    }
}
