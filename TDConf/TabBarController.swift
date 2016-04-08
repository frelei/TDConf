//
//  TabBarController.swift
//  TDC
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    // MARK: INITIALIZER
    func initialize(){

        for (index,viewController) in self.viewControllers!.enumerate(){
            switch(index){
            case 0:
                viewController.tabBarItem.title = "Schedule"
                viewController.tabBarItem.tag = 0
//                viewController.tabBarItem.image = UIImage(named: "house")
            case 1:
                viewController.tabBarItem.title = "Attendees"
                viewController.tabBarItem.tag = 1
//                viewController.tabBarItem.image = UIImage(named: "notification-1")
            case 2:
                viewController.tabBarItem.title = "Profile"
                viewController.tabBarItem.tag = 2
//                viewController.tabBarItem.image = UIImage(named: "Businessman")
            default: break
            }
        }
    }
    

}
