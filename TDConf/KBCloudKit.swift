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

/**
    CKRecord extension provide new functionalities to this data type
 */
extension CKRecord
{
    
    /**
        Save an object in cloudkit.
        
        - parameter: classType, the type of the class 
        - parameter: container, the default (nil) is the default container
        - parameter: database, the default is the public database
        - parameter: completion, closure where returns the result and the error
     
    */
    func save<T: KBRecord>(classType: T.Type, container: String? = nil, database: DATABASE_TYPE = .PUBLIC, completion:(result:CKRecord?, error: NSError?) -> Void)
    {
        KBCloudKit.dataBaseFromContainer(container, type: database).saveRecord(self) { (record, error) in
            if error == nil
            {
                completion(result: T(record:record!) as? CKRecord, error:nil)
            }
            else
            {
                Logging(error?.description)
                completion(result: nil, error: error)
            }
        }
    }
    
    /**
        Delete an object in cloudkit.
     
        - parameter: container, The default (nil) is the default container
        - parameter: database, The default (.PUBLIC) is the default database
        - paramter: completion, closure has the result and the error
    */
    func delete(container: String? = nil, database:DATABASE_TYPE = .PUBLIC, completion:(result:CKRecordID?, error: NSError?) -> Void)
    {
        KBCloudKit.dataBaseFromContainer(container, type: database).deleteRecordWithID(self.recordID) { (recordID, error) in
            if error == nil
            {
                completion(result: recordID, error: nil)
            }
            else
            {
                Logging(error?.description)
                completion(result: nil, error: nil)
            }
        }
    }
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
    static func fetchAll<T:KBRecord>(type: String, classType: T.Type ,completion:(result:[CKRecord]?, error: NSError?) -> Void)
    {
        let predicate = NSPredicate(value:true)
        let sortDescriptor = NSSortDescriptor(key: KEY_START_DATE, ascending: true)
        let queryOperation = KBQueryOperation(recordType: type, predicate: predicate, resultLimit: nil, sort: sortDescriptor)
        queryOperation.performQuery { (result, error) in
            if error == nil
            {
                let objects = result?.map({ (record) -> CKRecord in
                    let k = T(record: record)
                    return k as! CKRecord;
                })
                completion(result: objects, error: nil)
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
    static func fetchByRecord<T: KBRecord>(classType: T.Type, recordID: CKRecordID, container: String? = nil, database: DATABASE_TYPE = .PUBLIC, completion:(result: CKRecord?, error: NSError?) -> Void)
    {
        KBCloudKit.dataBaseFromContainer(container, type: database).fetchRecordWithID(recordID) { (record, error) in
            if error == nil
            {
                completion(result: T(record: record!) as? CKRecord, error: nil)
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
  
}