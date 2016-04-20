//
//  NotificationVC.swift
//  TDConf
//
//  Created by Rodrigo Leite on 10/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import CloudKit

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var lblError: UILabel!
    
    var connections = [Connection]()
    var attendeeConnection = [Attendee]()
    var query: KBQueryOperation<Connection>?
    var currentAttendee: Attendee?
    let refreshController = UIRefreshControl()
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.refreshController.beginRefreshing();
        self.loadData()
    }
    
    // MARK: DATA PROVIDER
    func loadData(){
        Attendee.attendeeUser { (result, error) in
            if error == nil && result != nil {
                self.currentAttendee = result
                let reference = CKReference( recordID: result!.record!.recordID, action: .DeleteSelf )
                let predicate = NSPredicate(format: "accepter == %@", reference)
                self.query = KBQueryOperation(recordType: "Connection", predicate: predicate, resultLimit: 50, sort: nil)
                self.query!.performQuery { (result, error) in
                    if error == nil {
                        
                        let objects = result?.map({ (element) -> CKRecordID in
                            return element.requesterReference!.recordID
                        })
                        
                        KBCloudKit.fetchRecordsByIDs("Attendee", classType: Attendee.self, records: objects!, completion: { (records, error) in
                            
                            dispatch_async(dispatch_get_main_queue(), {

                            self.attendeeConnection.appendContentsOf(records!)
                           
                            if self.attendeeConnection.count == 0 {
                                self.lblError.text = "You don't have notifications right now. Pull down to refresh."
                                self.lblError.hidden = false
                            }
                                
                            self.tableView.reloadData()
                            self.refreshController.endRefreshing()
                            })
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                        self.lblError.text = "Notifications couldn't be loaded right now. Pull down to try again"
                        self.lblError.hidden = false
                        Logging(error?.description)
                        self.refreshController.endRefreshing()
                        })
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                self.lblError.text = "Notifications couldn't be loaded right now. Did you register already? Go to profile tab. \n\n If you have already done so, pull down to refresh"
                self.lblError.hidden = false
                Logging(error?.description)
                self.refreshController.endRefreshing()
                })
            }
        }
    }
    
    
    // MARK: TABLEVIEW
    func configureTableView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        refreshController.addTarget(self, action: #selector(NotificationVC.handleRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshController)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attendeeConnection.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NOTIFICATION_CELL", forIndexPath: indexPath)
        let c = cell.viewWithTag(2) as! UILabel
        let i = cell.viewWithTag(1) as! UIImageView
        let v = self.attendeeConnection[indexPath.row]
        i.roundImage()
        UIImage.loadImageFrom(v.profileImage?.fileURL) { (image) in
            dispatch_async(dispatch_get_main_queue(), {
                i.image = image
            })
        }
        c.text = v.name
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let attendee = self.attendeeConnection[indexPath.row]
        self.performSegueWithIdentifier("goToProfileSegue", sender: attendee)
    }
    
    func handleRefresh(refreshController: UIRefreshControl){
        self.attendeeConnection = [Attendee]()
        self.refreshController.beginRefreshing();
        self.loadData();
    }
    
    @IBAction func btnConfirmClicked(sender: UIButton) {
        sender.enabled = false
        let cell = sender.superview?.superview as! AroundCell
        let indexPath = self.tableView.indexPathForCell(cell)
        let connection = self.connections[indexPath!.row]
        connection.accepted = "1"
        
        if self.currentAttendee?.connection != nil{
            self.currentAttendee?.connection?.append(connection.requesterReference!)
        }else{
            self.currentAttendee?.connection = [CKReference]()
            self.currentAttendee?.connection?.append(connection.requesterReference!)
        }
        
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [connection.record!, self.currentAttendee!.record!], recordIDsToDelete: nil)
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
