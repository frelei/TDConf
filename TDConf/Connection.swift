//
//  Connection.swift
//  TDConf
//
//  Created by Rodrigo Leite on 19/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import CloudKit


class Connection: KBRecord
{
    static var TYPE : String = "Connection"
    var record: CKRecord?
    
    var requesterReference: CKReference?{
        didSet{
            self.record!["requester"] = self.requesterReference
        }
    }

    var accepterReference: CKReference?{
        didSet{
            self.record!["accepter"] = self.accepterReference
        }
    }
    
    var accepted: String?{
        didSet{
            self.record!["accepted"] = self.accepted
        }
    }
    
    
    required convenience init(record: CKRecord){
        self.init()
        self.record = record
        self.requesterReference = record["requester"] as? CKReference
        self.accepterReference = record["accepter"] as? CKReference
        self.accepted = record["accepted"] as? String
    }
    
}
