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
            let reference = CKReference( recordID: recordID!, action: .DeleteSelf )
            if self.query == nil{
                self.query = KBQueryOperation<Attendee>(recordType: "Attendee"
                    , predicate: NSPredicate( format: "user != %@", reference )
                    , resultLimit: 50
                    , sort: NSSortDescriptor(key: "creationDate", ascending: false))
            }
            
            self.query!.performQuery{ (result, error) in
                
                let errorText = "You need to register first. For that, go to profile tab. If you have already done so, pull down to refresh."

                if error == nil
                {
                    self.attendees.appendContentsOf(result!)
                    Attendee.attendeeUser { (result, error) in
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            if self.attendees.count == 0 {
                                self.lblYouNeedToRegister.text = "There are no people around at the moment"
                                self.lblYouNeedToRegister.hidden = false
                            }
                            else if error == nil && result != nil {
                                self.lblYouNeedToRegister.hidden = true
                                self.currentAttendee = result
                                self.tableView.reloadData()
                            } else {
                                self.lblYouNeedToRegister.text = errorText
                                self.lblYouNeedToRegister.hidden = false
                            }
                            
                            self.refreshController.endRefreshing()
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.lblYouNeedToRegister.text = errorText
                        self.lblYouNeedToRegister.hidden = false
                        self.refreshController.endRefreshing()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let attendee = self.attendees[indexPath.row]
        self.performSegueWithIdentifier("goToProfileSegue", sender: attendee)
    }
    
    func handleRefresh(refreshController: UIRefreshControl){
        self.query!.resetQuery()
        self.attendees = [Attendee]()
        self.refreshController.beginRefreshing()
        self.loadData()
    }
    
    func btnClickedConnect(sender: UIButton){
        
        let cell = sender.superview?.superview as! AroundCell
        let accepter = cell.attendee
        
        // Adding subscription
        KBCloudKit.container().fetchUserRecordIDWithCompletionHandler { (recordID, error) in
            let attendeeReference = CKReference(recordID: self.currentAttendee!.record!.recordID, action: .DeleteSelf)
            let notification = CKNotificationInfo()
            notification.alertBody = "\(accepter.name!) wants share information with you"
            notification.shouldSendContentAvailable = true
            notification.soundName = UILocalNotificationDefaultSoundName
    
            let predicate = NSPredicate(format: "requester == %@ && accepted == %@", attendeeReference, "1")
            KBCloudKit.registerSubscription("Connection", notificationInfo: notification, predicate: predicate, options: .FiresOnRecordUpdate)
        }
        
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
    
     // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToProfileSegue" {
            let profileVC = segue.destinationViewController as! ProfileVC
            profileVC.attendee = sender as? Attendee
        }
     }
}
