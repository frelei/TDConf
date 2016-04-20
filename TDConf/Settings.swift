//
//  Settings.swift
//  TDConf
//
//  Created by Rodrigo Leite on 19/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import Foundation
import CloudKit

let USER_RECORDID = "RECORD_ID"
let ATTENDEE_RECORD = "ATTENDEE_RECORD"

class Settings {
    
    static let sharedInstance = Settings()
    private var defaults : NSUserDefaults
    private init() {
        self.defaults = NSUserDefaults()
    }
    
    func saveUserRecordID(recordID: String){
        self.defaults.setObject(recordID, forKey: USER_RECORDID)
    }
    
    func userRecordID() -> String?{
        return self.defaults.objectForKey(USER_RECORDID) as? String
    }
    
    func saveAteendee(record: CKRecord){
        self.defaults.setObject(record, forKey: ATTENDEE_RECORD)
    }
    
    func attendee() -> CKRecord?{
        return self.defaults.objectForKey(ATTENDEE_RECORD) as? CKRecord
    }
}
