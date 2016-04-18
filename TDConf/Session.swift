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


class Session: CKRecord, KBRecord
{
    static var TYPE : String = SESSION_RECORD_TYPE
    
    var title: String!{
        didSet{
            self[KEY_TITLE] = self.title
        }
    }
    var startDate: NSDate!{
        didSet{
            self[KEY_START_DATE] = self.startDate
        }
    }
    var endDate: NSDate!{
        didSet{
            self[KEY_END_DATE] = self.endDate
        }
    }
    var sessionDescription: String!{
        didSet{
            self[KEY_DESCRIPTION] = self.sessionDescription
        }
    }
    var author: String!{
        didSet{
            self[KEY_AUTHOR] = self.author
        }
    }
    
    required convenience init(record: CKRecord)
    {
        self.init(recordType: SESSION_RECORD_TYPE)
        self.title = record[KEY_TITLE] as! String
        self.startDate = record[KEY_START_DATE] as! NSDate
        self.endDate = record[KEY_END_DATE] as! NSDate
        self.author = record[KEY_AUTHOR] as! String
        self.sessionDescription = record[KEY_DESCRIPTION] as! String
    }
    
    
//    func customMirror() -> Mirror {
//        let children = DictionaryLiteral<String, Any>(dictionaryLiteral:
//            ("title", self["title"]), ("startDate", self["startDate"]),
//                                   ("endData", self["endDate"]), ("description", self["description"]),
//                                   ("author", self["author"]))
//        
//        return Mirror.init(Session.self, children: children,
//                           displayStyle: Mirror.DisplayStyle.Struct, 
//                           ancestorRepresentation:.Suppressed)
//    }
    
    
}
