//
//  ScheduleVM.swift
//  TDConf
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import Foundation

struct ScheduleVM: ScheduleCellRepresentable{
    
    var title: String
    var author: String
    var description: String
    var time: String
    
    var session: Session{
        didSet{
            self.title = session.title
            self.author = session.author
            self.description = session.description
            self.time = "\(session.startDate.getHour()):\(session.startDate.getMinutes()) às \(session.endDate.getHour()):\(session.endDate.getMinutes())"
        }
    }
}