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
    
    var connections = [Connection]()
    var attendeeConnection = [Attendee]()
    var query: KBQueryOperation<Connection>?
    
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadData()
    }

    
    // MARK: DATA PROVIDER
    func loadData(){
        
        Attendee.attendeeUser { (result, error) in
            if error == nil && result != nil {
                let reference = CKReference( recordID: result!.record!.recordID, action: .DeleteSelf )
                let predicate = NSPredicate(format: "requester == %@", reference)
                self.query = KBQueryOperation(recordType: "Connection", predicate: predicate, resultLimit: 50, sort: nil)
                self.query!.performQuery { (result, error) in
                    if error == nil{
                        let objects = result?.map({ (element) -> CKRecordID in
                            return element.accepterReference!.recordID
                        })
                        KBCloudKit.fetchRecordsByIDs("Attendee", classType: Attendee.self, records: objects!, completion: { (records, error) in
                            self.attendeeConnection.appendContentsOf(records!)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableView.reloadData()
                            })
                        })
                        
                    }else{
                        Logging(error?.description)
                    }
                }
            } else {
                Logging(error?.description)
            }
        }
    }
    
    
    // MARK: TABLEVIEW
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attendeeConnection.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NOTIFICATION_CELL", forIndexPath: indexPath)
        let c = cell.viewWithTag(2) as! UILabel
        let v = self.attendeeConnection[indexPath.row]
        c.text = v.name
        return cell
        
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
