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
    @IBOutlet weak var lblEmail: UILabel!
    
    var attendee: Attendee?
    
    // MARK: VC Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imgAvatar.roundImage()
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
        self.lblEmail.text = self.attendee?.email
        UIImage.loadImageFrom(self.attendee!.profileImage.fileURL) { (image) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.imvBackgroundImage.image = image
                self.imgAvatar.image = image
            })
        }
    }
    
    @IBAction func editBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("goToEditProfileSegue", sender: self.attendee)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nav = segue.destinationViewController as! UINavigationController
        let editVC = nav.viewControllers.first as! EditProfile
        editVC.attendee = sender as? Attendee
    }
    
    

}
