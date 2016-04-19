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
}


class AroundCell: UITableViewCell {

    @IBOutlet weak var imvProfileImage: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var btnConnect: UIButton!
    
    
    func configure(presentable: AroundCellPresentable)
    {
        self.imvProfileImage.roundImage()
        UIImage.loadImageFrom(presentable.profile) { (image) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.imvProfileImage.image = image
            })
        }
        self.lblUsername.text = presentable.username
        self.lblProfession.text = presentable.profession
    }

}
