//
//  AroundCell.swift
//  TDConf
//
//  Created by Rodrigo Leite on 10/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit

protocol AroundCellPresentable
{
    var username: String { get }
    var profession: String { get }
    var profile: NSURL {  get }
    var attendee: Attendee { get }
}

class AroundCell: UITableViewCell {

    @IBOutlet weak var imvProfileImage: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var btnConnect: UIButton!
    var attendee : Attendee!
    
    func configure(presentable: AroundCellPresentable)
    {
        self.attendee = presentable.attendee
        self.imvProfileImage.roundImage()
        UIImage.loadImageFrom(presentable.profile) { (image) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.imvProfileImage.image = image
            })
        }
        self.lblUsername.text = presentable.username
        self.lblProfession.text = presentable.profession
    }

    func configure(presentable: AroundCellPresentable, attendee: Attendee){
        self.configure(presentable)
        let connected = attendee.connection?.filter({ (element) -> Bool in
            return  presentable.attendee.record?.recordID == element.recordID
        })
        self.btnConnect.enabled = (connected != nil && connected?.count > 0)  ? false : true
    }
}