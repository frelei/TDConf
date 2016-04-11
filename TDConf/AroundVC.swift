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
    
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AROUND_CELL, forIndexPath: indexPath)
        
        
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
