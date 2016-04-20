//
//  AroundVC.swift
//  TDConf
//
//  Created by Rodrigo Leite on 10/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import CloudKit

class AroundVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: CONSTANTS
    let AROUND_CELL = "AROUND_CELL"
    let refreshController = UIRefreshControl()
    
    // MARK: IBOULET
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var lblYouNeedToRegister: UILabel!
    
    // MARK: VARIABLE
    var attendees = [Attendee]()
    var currentAttendee : Attendee?
    var query : KBQueryOperation<Attendee>?
    
    
    // MARK: DATA PROVIDER
    func loadData(){
        
        KBCloudKit.container().fetchUserRecordIDWithCompletionHandler { (recordID, error) in
            //let recordID = CKRecordID(recordName: recordID!)
            let reference = CKReference( recordID: recordID!, action: .DeleteSelf )
            if self.query == nil{
                self.query = KBQueryOperation<Attendee>(recordType: "Attendee"
                    , predicate: NSPredicate( format: "user != %@", reference )
                    , resultLimit: 50
                    , sort: NSSortDescriptor(key: "creationDate", ascending: false))
            }
            
            self.query!.performQuery{ (result, error) in
                if error == nil
                {
                    self.attendees.appendContentsOf(result!)
                    Attendee.attendeeUser { (result, error) in
                        dispatch_async(dispatch_get_main_queue(), {
                            if error == nil && result != nil {
                                self.lblYouNeedToRegister.hidden = true;
                                self.currentAttendee = result
                                self.tableView.reloadData()
                            } else {
                                self.lblYouNeedToRegister.hidden = false;
                            }
                            self.refreshController.endRefreshing();
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.lblYouNeedToRegister.hidden = false;
                        self.refreshController.endRefreshing();
                    })
                }
            }
        }
    }
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.refreshController.beginRefreshing();
        self.loadData();
    }
    
    // MARK: TableView
    func configureTableView() {
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        refreshController.addTarget(self, action: #selector(AroundVC.handleRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshController)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attendees.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AROUND_CELL, forIndexPath: indexPath) as! AroundCell
        let attendee = self.attendees[indexPath.row]
        let aroundVM = AroundVM(attendee: attendee)
        cell.configure(aroundVM, attendee: self.currentAttendee!)
        cell.btnConnect.addTarget(self, action: #selector(AroundVC.btnClickedConnect(_:)), forControlEvents: .TouchUpInside)
        return cell;
    }
    
    func btnClickedConnect(sender: UIButton){
        
        let cell = sender.superview?.superview as! AroundCell
        let accepter = cell.attendee
        
        let accepterReference = CKReference(recordID: accepter!.record!.recordID, action: .DeleteSelf)
        
        let notification = CKNotificationInfo()
        notification.alertBody = "\(accepter.name!) wants share information with you"
        notification.shouldSendContentAvailable = true
        notification.soundName = UILocalNotificationDefaultSoundName
        
        KBCloudKit.registerSubscription("Connection", notificationInfo: notification, predicate: NSPredicate(format: "accepter == %@ && accepted == %@", accepterReference, "1"), options: .FiresOnRecordUpdate)

        let connection = CKRecord(recordType: "Connection")
        connection["requester"] = CKReference(recordID: self.currentAttendee!.record!.recordID, action: .DeleteSelf)
        connection["accepter"] = CKReference(recordID: accepter.record!.recordID, action: .DeleteSelf)
        connection["accepted"] = "0"
        
        let reference = CKReference(recordID: accepter.record!.recordID, action: .DeleteSelf)
        if self.currentAttendee?.connection != nil{
            self.currentAttendee?.connection?.append(reference)
        }else{
            self.currentAttendee?.connection = [CKReference]()
            self.currentAttendee?.connection?.append(reference)
        }
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [connection, self.currentAttendee!.record!], recordIDsToDelete: nil)
        modifyOperation.modifyRecordsCompletionBlock = {(records: [CKRecord]?, recordIDs: [CKRecordID]?, error: NSError?) in
            if error == nil{
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
        KBCloudKit.dataBaseFromContainer(type: .PUBLIC).addOperation(modifyOperation)
    }
    
    func handleRefresh(refreshController: UIRefreshControl){
        self.query?.operation = nil;
        self.attendees = [Attendee]();
        self.refreshController.beginRefreshing();
        self.loadData();
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
