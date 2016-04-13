//
//  KBQueryOperation.swift
//  TDConf
//
//  Created by Rodrigo Leite on 11/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import CloudKit

class KBQueryOperation
{
    var objects: [CKRecord]?
    var query: CKQuery?
    var cursor: CKQueryCursor?
    var limit: Int?
    
    init(recordType:String, predicate: NSPredicate, resultLimit: Int?, sort: NSSortDescriptor?)
    {
        self.query = CKQuery(recordType: recordType, predicate: predicate)
        if let sorting = sort{
            self.query?.sortDescriptors = [sorting]
        }
        self.limit = resultLimit
        self.objects = [CKRecord]()
    }
    
    func performQuery(completion: (result:[CKRecord]?, error: NSError?) -> Void)
    {
        let operation = cursor == nil ? CKQueryOperation(query: self.query!)
                                      : CKQueryOperation(cursor: cursor!)
        if let resultLimit = limit
        {
            operation.resultsLimit = resultLimit
        }
        
        operation.recordFetchedBlock = { (record: CKRecord) -> Void in
            self.objects?.append(record)
        }
        
        operation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
            if error != nil
            {
                completion(result: nil, error: error)
                return
            }
            self.cursor = cursor
            completion(result: self.objects, error: nil)
        }
        CKContainer.defaultContainer().publicCloudDatabase.addOperation(operation)
    }
}