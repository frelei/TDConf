//
//  ScheduleVM.swift
//  TDConf
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import Foundation

struct ScheduleVM: ScheduleCellRepresentable{
    
    var title: String = ""
    var author: String = ""
    var description: String = ""
    var time: String = ""    
    
    init(session: Session)
    {
        self.title = session.title
        self.author = session.author
        self.description = session.sessionDescription
        
        let startHour = self.timeToString(session.startDate.getHour())
        let startMinutes = self.timeToString(session.endDate.getMinutes())
        let endHour = self.timeToString(session.endDate.getHour())
        let endMinutes = self.timeToString(session.endDate.getMinutes())
        self.time = "\(startHour):\(startMinutes) às \(endHour):\(endMinutes)"
    }
    
    
    func timeToString(time: Int) -> String{
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    
}