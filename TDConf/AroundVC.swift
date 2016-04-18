//
//  AroundVC.swift
//  TDConf
//
//  Created by Rodrigo Leite on 10/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit

class AroundVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: CONSTANTS
    let AROUND_CELL = "AROUND_CELL"
    
    // MARK: IBOULET
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: VARIABLE
    var attendees = [Attendee]()
    
    
    // MARK: DATA PROVIDER
    func loadData(){
        let query = KBQueryOperation(recordType: "Attendee"
            , predicate: NSPredicate(value: true)
            , resultLimit: nil
            , sort: NSSortDescriptor(key: "Created", ascending: false))
        
        query.performQuery { (result, error) in
            if error == nil
            {
                dispatch_async(dispatch_get_main_queue(), { 
                    self.attendees.appendContentsOf(result as! [Attendee])
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.loadData()
    }

    // MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attendees.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AROUND_CELL, forIndexPath: indexPath) as! AroundCell
        let attendee = self.attendees[indexPath.row]
        let aroundVM = AroundVM(attendee: attendee)
        cell.configure(aroundVM)
        return cell;
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
