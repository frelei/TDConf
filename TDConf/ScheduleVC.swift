//
//  ScheduleVC.swift
//  TDConf
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit

class ScheduleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let CELL_IDENTIFIER = "SESSION_CELL"
    var sessions = [Session]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        
        Session.fetchAll { (result, error) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.sessions = result!
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: Configure
    func configureTableView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 110
    }
    
    
    // MARK: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! ScheduleCell
        let session = self.sessions[indexPath.row]
        let scheduleVC = ScheduleVM(session: session)
        cell.configure(scheduleVC)
        return cell;
    }
}
