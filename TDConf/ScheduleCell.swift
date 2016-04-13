//
//  ScheduleCell.swift
//  TDConf
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit

protocol ScheduleCellRepresentable{
    var title: String { get }
    var author: String {  get }
    var description: String { get }
    var time: String { get }
}

extension ScheduleCellRepresentable{
    var titleFontSize: UIFont { return  UIFont(name: TITILLIUM.SEMI_BOLD.rawValue, size: 19)! }
    var authorFontSize: UIFont { return  UIFont(name: TITILLIUM.LIGHT.rawValue, size: 13)! }
    var timeFontSize: UIFont { return UIFont(name: TITILLIUM.ITALIC.rawValue, size:11)! }
    var descriptionFontSize: UIFont { return UIFont(name: TITILLIUM.REGULAR.rawValue, size:15)! }
}

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var lblTitleSession: UILabel!
    @IBOutlet weak var lblAuthorSession: UILabel!
    @IBOutlet weak var lblDescriptionSession: UILabel!
    @IBOutlet weak var lblTimeSession: UILabel!
  
    func configure(scheduleVM: ScheduleCellRepresentable){
        self.lblTitleSession.text = scheduleVM.title
        self.lblTitleSession.font = scheduleVM.titleFontSize
        
        self.lblTimeSession.text = scheduleVM.time
        self.lblTimeSession.font = scheduleVM.timeFontSize
        
        self.lblAuthorSession.text = scheduleVM.author
        self.lblAuthorSession.font = scheduleVM.authorFontSize
        
        self.lblDescriptionSession.text = scheduleVM.description
        self.lblDescriptionSession.font = scheduleVM.descriptionFontSize
        
    }
    
}
