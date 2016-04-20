//
//  KBCloudKit.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

protocol KBRecord
{
    static var TYPE: String { get }
    init(record: CKRecord)
}

enum DATABASE_TYPE {
    case PUBLIC, PRIVATE
}


class KBCloudKit
{
    //static let sharedInstance = KBCloudKit()
    
    /**
         Cloudkit database related with container
     
        - parameter:: name: It's the container's name. if the parameter nil, it's the default container
        - paramter:: type: It's the public or private CKDatabase. Default is public
        - return: The CKDatabase from a CKContainer
    */
    static func dataBaseFromContainer(name: String? = nil, type: DATABASE_TYPE) -> CKDatabase
    {
        if let containerName = name
        {
            return type == .PRIVATE ? CKContainer(identifier: containerName).privateCloudDatabase :
                                      CKContainer(identifier: containerName).publicCloudDatabase

        }
        else
        {
            return type == .PRIVATE ? CKContainer.defaultContainer().privateCloudDatabase :
                                      CKContainer.defaultContainer().publicCloudDatabase
        }
    }
    
    /**
        Cloudkit container
        
        - Paramter: name. The default is nil and retrieve the default container
    */
    static func container(name: String? = nil) -> CKContainer
    {
        if let containerName = name
        {
            return CKContainer(identifier: containerName)
        }
        else
        {
            return CKContainer.defaultContainer()
        }
    }
    
    /**
        FetchAll register from a Type
        
        - parameter: type: The name of the class
        - parameter: classType: The Type of the class related with the code
        - parameter: completion: closure with result and error ```(result:[CKRecord]?, error: NSError?)```
     
        - Example: ``` KBCloudKit.fetchAll(Session.TYPE, classType: Session.self) ```
    */
    
    static func fetchAll<T:KBRecord>(type: String, classType: T.Type, completion:(result:[T]?, error: NSError?) -> Void)
    {
        let predicate = NSPredicate(value:true)
        let sortDescriptor = NSSortDescriptor(key: KEY_START_DATE, ascending: true)
        let queryOperation = KBQueryOperation<T>(recordType: type, predicate: predicate, resultLimit: nil, sort: sortDescriptor)
        queryOperation.performQuery { (result, error) in
            if error == nil
            {
                completion(result: result, error: nil)
            }
            else
            {
                Logging(error?.description)
                completion(result: nil, error: error)
            }
        }
    }
    
    /**
        Fetch record on Cloudkit by RecordID
     
        - parameter: classType: Type of the class related with the object
        - parameter: recordID : The object Identifier
        - parameter: container: Where the object is located. The default is the default container
        - paramter: database: The database where is register is recorded. The default is public
    */
    static func fetchByRecord<T: KBRecord>(classType: T.Type, recordID: CKRecordID, container: String? = nil, database: DATABASE_TYPE = .PUBLIC, completion:(result: T?, error: NSError?) -> Void)
    {
        KBCloudKit.dataBaseFromContainer(container, type: database).fetchRecordWithID(recordID) { (record, error) in
            if error == nil
            {
                completion(result: T(record: record!), error: nil)
            }
            else
            {
                Logging(error?.description)
                completion(result: nil, error: error)
            }
        }
    }
    
    /**
        CheckStatus analisys the user's status on the Cloudkit
        
        - paramater: completion, closure ```(result: Bool, error: NSError)```
    */
    static func checkStatus(completion:(result:Bool, error: NSError?) -> Void){
        KBCloudKit.container().accountStatusWithCompletionHandler { (accountStatus, error) in
            switch accountStatus{
            case .Available, .Restricted: completion(result: true, error: nil)
            case .NoAccount, .CouldNotDetermine: completion(result: false, error: error)
            }
        }
    }
    
    static func registerSubscription(type: String, notificationInfo: CKNotificationInfo, predicate: NSPredicate, options: CKSubscriptionOptions){
        KBCloudKit.dataBaseFromContainer(type: .PUBLIC).fetchAllSubscriptionsWithCompletionHandler { (subscriptions, error) in
            let createdSubscriptions = subscriptions?.filter({ (element) -> Bool in
                return element.predicate == predicate && element.recordType == type
            })
            
            if createdSubscriptions?.count == 0{
                let subscription = CKSubscription(recordType: type, predicate: predicate, options: options)
                subscription.notificationInfo = notificationInfo
                KBCloudKit.dataBaseFromContainer(type: .PUBLIC).saveSubscription(subscription) { (subscription, error) in
                    if error == nil{
                        
                    }else{
                        Logging(error?.description)
                    }
                }
            } else {
                Logging("createdSubscriptions?.count is different than 0")
            }
        }
    }
    
    static func fetchRecordsByIDs<T:KBRecord>(type: String, classType: T.Type, records:[CKRecordID], completion:(records: [T]?, error: NSError?) -> Void){
        let fetchOperation = CKFetchRecordsOperation(recordIDs: records)
        fetchOperation.fetchRecordsCompletionBlock =  { (records: [CKRecordID : CKRecord]?, error: NSError?) in
            if error == nil{
                var objects = [T]()
                for (_,value) in records!{
                    objects.append( T(record:value) )
                }
                completion(records: objects, error: nil)
            }else{
                Logging(error)
                completion(records: nil, error: error)
            }
        }
        KBCloudKit.dataBaseFromContainer(type: .PUBLIC).addOperation(fetchOperation)
    }
    
    
}