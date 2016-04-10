//
//  TabBarController.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit

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
    

}
