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

let SESSION_RECORD_TYPE = "Session"
let KEY_TITLE = "title"
let KEY_START_DATE = "startDate"
let KEY_END_DATE = "endDate"
let KEY_AUTHOR = "author"
let KEY_DESCRIPTION = "description"


class Session: KBRecord
{
    static var TYPE : String = SESSION_RECORD_TYPE
    var record: CKRecord?
    
    var title: String!{
        didSet{
            self.record![KEY_TITLE] = self.title
        }
    }
    var startDate: NSDate!{
        didSet{
            self.record![KEY_START_DATE] = self.startDate
        }
    }
    var endDate: NSDate!{
        didSet{
            self.record![KEY_END_DATE] = self.endDate
        }
    }
    var sessionDescription: String!{
        didSet{
            self.record![KEY_DESCRIPTION] = self.sessionDescription
        }
    }
    var author: String!{
        didSet{
            self.record![KEY_AUTHOR] = self.author
        }
    }
       
    required convenience init(record: CKRecord)
    {
        self.init()
        self.title = record[KEY_TITLE] as! String
        self.startDate = record[KEY_START_DATE] as! NSDate
        self.endDate = record[KEY_END_DATE] as! NSDate
        self.author = record[KEY_AUTHOR] as! String
        self.sessionDescription = record[KEY_DESCRIPTION] as! String
    }
    
    convenience init(recordType: String)
    {
        self.init()
        record = CKRecord(recordType: SESSION_RECORD_TYPE)
    }
    
}
