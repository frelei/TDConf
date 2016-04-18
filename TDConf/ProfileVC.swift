//
//  ProfileVC.swift
//  TDConf
//
//  Created by Rodrigo Leite on 08/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var imvBackgroundImage: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    
    var attendee: Attendee?
    
    // MARK: VC Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Attendee.attendeeUser { (result, error) in
            if error == nil && result != nil{
                self.attendee = result as? Attendee
                dispatch_async(dispatch_get_main_queue(), { 
                    self.configureView()
                })
            }
        }
    }

    func configureView(){
        self.lblName.text = self.attendee?.name
        self.lblBio.text = self.attendee?.about
        self.lblProfession.text = self.attendee?.profession
        UIImage.loadImageFrom(self.attendee!.profileImage.fileURL) { (image) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.imvBackgroundImage.image = image
                self.imgAvatar.image = image
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
