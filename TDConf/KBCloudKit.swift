//
//  KBCloudKit.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import Foundation
import CloudKit

protocol KBRecord
{
    static var TYPE: String { get }
    init(record: CKRecord)
}

extension CKRecord
{
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
        Get From Cloudkit the container and the database related with
     
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
        CRUD
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
    
    static func checkStatus(completion:(result:Bool, error: NSError?) -> Void){
        KBCloudKit.container().accountStatusWithCompletionHandler { (accountStatus, error) in
            switch accountStatus{
            case .Available, .Restricted: completion(result: true, error: nil)
            case .NoAccount, .CouldNotDetermine: completion(result: false, error: error)
            }
            
        }
    }
    
    
}