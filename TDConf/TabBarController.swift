//
//  TabBarController.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import CloudKit

class TabBarController: UITabBarController {

    // MARK: CONSTANTS
    let SCHEDULE = "Schedule"
    let ATTENDEES = "Attendees"
    let AROUND_ME = "Around Me"
    let PROFILE = "Profile"
    let NOTIFICATION = "Notification"
    let CALENDAR_ICON = "Calendar"
    let AROUND_ICON = "Around"
    let BELL_ICON = "Notification"
    let PROFILE_ICON = "Profile"
    
    // MARK: VC Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let notificationAccountChange = #selector(TabBarController.accountChangednotification(_:))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: notificationAccountChange, name: CKAccountChangedNotification, object: nil)
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: CKAccountChangedNotification, object: nil)
    }
    
    
    // MARK: INITIALIZER
    func initialize()
    {
        for (index,viewController) in self.viewControllers!.enumerate()
        {
            switch(index)
            {
            case 0:
                viewController.tabBarItem.title = SCHEDULE
                viewController.tabBarItem.tag = 0
                viewController.tabBarItem.image = UIImage(named: CALENDAR_ICON)
            case 1:
                viewController.tabBarItem.title = AROUND_ME
                viewController.tabBarItem.tag = 1
                viewController.tabBarItem.image = UIImage(named: AROUND_ICON)
            case 2:
                viewController.tabBarItem.title = NOTIFICATION
                viewController.tabBarItem.tag = 2
                viewController.tabBarItem.image = UIImage(named: NOTIFICATION)
            case 3:
                viewController.tabBarItem.title = PROFILE
                viewController.tabBarItem.tag = 3
                viewController.tabBarItem.image = UIImage(named: PROFILE_ICON)
            default: break
            }
        }
    }
    
    // MARK: NOTIFICATION
    func accountChangednotification(notification: NSNotification)
    {
        Logging(notification)
        KBCloudKit.checkStatus { (result, error) in
            if !result || error != nil{
                Logging(error?.description)
            }
            else{

            }
        }
    }
    
    // MARK: TABBARDELEGATe
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem)
    {
        if item.tag > 0{
            KBCloudKit.checkStatus({ (result, error) in
                if !result || error != nil
                {
                    Logging(error?.description)
                    self.logInIcloud()
                }
                else
                {
                    // TODO: change the layout
                }
            })
        }
    }
    
    func logInIcloud(){
        let title = "Sign in to iCloud"
        let message = "Sign in to your iCloud account or create a new Apple ID and Turn on iCloud Drive to have full access to the app."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let goSettingsAction = UIAlertAction(title: "Settings", style: .Default) { (action) in
            dispatch_async(dispatch_get_main_queue(), { 
                UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=CASTLE")!)
            })
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) {(action) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.selectedIndex = 0
            })
        }
        
        alert.addAction(goSettingsAction)
        alert.addAction(cancel)
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
    }  
}
