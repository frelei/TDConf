//
//  Atendee.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import CloudKit

let ATTENDEE = "Attendee"
let KEY_NAME = "name"
let KEY_ABOUT = "about"
let KEY_PROFESSION = "profession"
let KEY_PROFILE = "photo"
let KEY_EMAIL = "email"

class Attendee: CKRecord, KBRecord
{
    
    static var TYPE : String = ATTENDEE
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
    var email: String!{
        didSet{
            self["email"] = self.email
        }
    }
    
    required convenience init(record: CKRecord)
    {
        self.init(recordType: SESSION_RECORD_TYPE)
        self.profileImage = record[KEY_PROFILE] as! CKAsset
        self.name = record[KEY_NAME] as! String
        self.about = record[KEY_ABOUT] as! String
        self.profession = record[KEY_PROFILE] as! String
        self.email = record[KEY_EMAIL] as! String
    }
    
    static func attendeeUser(completion:(result: CKRecord?, error: NSError?) -> Void){
            KBCloudKit.container().fetchUserRecordIDWithCompletionHandler { (recordID, error) in
                if error == nil{
                        let reference = CKReference(recordID: recordID!, action: .DeleteSelf)
                        let predicate = NSPredicate(format: "user == %@", reference)
                        let query = KBQueryOperation(recordType: ATTENDEE, predicate: predicate, resultLimit: nil, sort: nil)
                        query.performQuery({ (result, error) in
                            if error == nil{
                                if result?.count > 0{
                                    let attendee = Attendee(record: (result?.first)!)
                                    completion(result: attendee, error: nil)
                                }else{
                                    completion(result: nil, error: nil)
                                }
                            }else{
                                Logging(error)
                                completion(result: nil, error: error)
                            }
                        })
                }else{
                    Logging(error?.description)
                    completion(result: nil, error: error)
                }
        }
    }
    
}
