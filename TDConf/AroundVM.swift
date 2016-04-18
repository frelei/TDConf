//
//  AroundVM.swift
//  TDConf
//
//  Created by Rodrigo Leite on 10/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import Foundation

struct AroundVM: AroundCellPresentable
{
    var username: String
    var profession: String
    var profile: NSURL
    
    init(attendee: Attendee)
    {
        self.profile = attendee.profileImage.fileURL
        self.username = attendee.name
        self.profession = attendee.profession
    }
}
