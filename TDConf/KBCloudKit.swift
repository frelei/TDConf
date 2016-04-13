//
//  KBCloudKit.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitBase
{
    func save()
    func delete()
    func retrieve()
}


class KBCloudKit
{
    
    private var container: CKContainer
    private let publicDB: CKDatabase
    private let privateDB: CKDatabase
    
    init()
    {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
        
    
}
