//
//  Atendee.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import CloudKit

let ATENDEE = "Atendee"
let KEY_NAME = "name"
let KEY_ABOUT = "about"
let KEY_PROFESSION = "profession"
let KEY_PROFILE = "photo"

class Attendee: CKRecord, KBRecord
{
    
    static var TYPE : String = ATENDEE
    var profileImage: CKAsset!{
        didSet{
            self["photo"] = self.profileImage 
        }
    }
    var name: String!{
        didSet{
            self["name"] = self.name
        }
    }
    var about: String!{
        didSet{
            self["about"] = self.about
        }
    }
    var profession: String!{
        didSet{
           self["profession"] = self.profession
        }
    }
    
    required convenience init(record: CKRecord)
    {
        self.init(recordType: SESSION_RECORD_TYPE)
        self.profileImage = record[KEY_PROFILE] as! CKAsset
        self.name = record[KEY_NAME] as! String
        self.about = record[KEY_ABOUT] as! String
        self.profession = record[KEY_PROFILE] as! String
    }
    
    
}
