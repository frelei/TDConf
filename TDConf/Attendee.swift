//
//  Atendee.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import CloudKit

let ATTENDEE_RECORD_TYPE = "Attendee"
let KEY_NAME = "name"
let KEY_ABOUT = "bio"
let KEY_PROFESSION = "profession"
let KEY_PROFILE = "photo"
let KEY_EMAIL = "email"
let KEY_REFERENCE = "user"
let KEY_REFERENCE_LIST = "connection"

class Attendee: KBRecord
{
    
    static var TYPE : String = ATTENDEE_RECORD_TYPE
    var record: CKRecord?
    
    var profileImage: CKAsset?{
        didSet{
            self.record![KEY_PROFILE] = self.profileImage
        }
    }
    var name: String?{
        didSet{
            self.record![KEY_NAME] = self.name
        }
    }
    var about: String?{
        didSet{
            self.record![KEY_ABOUT] = self.about
        }
    }
    var profession: String?{
        didSet{
           self.record![KEY_PROFESSION] = self.profession
        }
    }
    var email: String?{
        didSet{
            self.record![KEY_EMAIL] = self.email
        }
    }
    var userReference: CKReference?{
        didSet{
            self.record![KEY_REFERENCE] = self.userReference
        }
    }
    var connection: [CKReference]?{
        didSet{
            self.record![KEY_REFERENCE_LIST] = self.connection
        }
    }
    
    
    convenience required init(record: CKRecord)
    {
        self.init()
        self.record = record
        self.profileImage = record[KEY_PROFILE] as? CKAsset
        self.name = record[KEY_NAME] as? String
        self.about = record[KEY_ABOUT] as? String
        self.profession = record[KEY_PROFESSION] as? String
        self.email = record[KEY_EMAIL] as? String
        self.userReference = record[KEY_REFERENCE] as? CKReference
        self.connection = record[KEY_REFERENCE_LIST] as? [CKReference]
    }
    
    convenience init(recordType: String)
    {
        self.init()
        record = CKRecord(recordType: ATTENDEE_RECORD_TYPE)
    }
    
    static func attendeeUser(completion:(result: Attendee?, error: NSError?) -> Void){
        
        KBCloudKit.container().fetchUserRecordIDWithCompletionHandler { (recordID, error) in
            
            if error != nil {
                Logging(error?.description)
                completion(result: nil, error: error)
            } else {
            let reference = CKReference(recordID: recordID!, action: .DeleteSelf)
                let predicate = NSPredicate(format: "user == %@", reference)
            
                let query = CKQuery(recordType:  "Attendee", predicate: predicate)
                CKContainer.defaultContainer().publicCloudDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (records, error) in
                    if error == nil{
                        if records?.count > 0 {
                            let a = Attendee( record: (records?.first!)!)
                            completion(result: a, error: error)
                        } else {
                            completion(result: nil, error: nil);
                        }
                    }else{
                        Logging(error?.description)
                        completion(result: nil, error: error)
                    }
                })
            }
        }
    }
    
}
