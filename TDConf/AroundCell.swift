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
    var profile: UIImage {  get }
}


class AroundCell: UITableViewCell {

    @IBOutlet weak var imvProfileImage: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    
    
    func configure(withPresentable presentable: AroundCellPresentable)
    {
        self.lblUsername.text = presentable.username
        self.lblProfession.text = presentable.profession
    }

}
