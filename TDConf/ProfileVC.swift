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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var btnTryAgain: UIButton!
    var attendee: Attendee?
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgAvatar.roundImage()
        self.loadAtendee()
    }
    
    // MARK: Load Data
    func loadAtendee() {
        Attendee.attendeeUser { (result, error) in
            if error == nil && result != nil {
                self.attendee = result
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.configureView()
                    self.btnTryAgain.hidden = true;
                })
            } else if result == nil && error == nil {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.btnTryAgain.hidden = true;
                self.performSegueWithIdentifier("goToEditProfileSegue", sender: self.attendee)
            } else {
                self.btnTryAgain.hidden = false;
                self.lblName.text = "";
                self.lblProfession.text = "";
                self.lblEmail.text = "";
                self.lblBio.text = "An error happened. Please try again later"
            }
        }
    }
    
    @IBAction func btnTryAgainClicked(sender: AnyObject) {
        self.activityIndicator.hidden = false;
        self.activityIndicator.startAnimating()
        loadAtendee()
    }
    
    
    func configureView(){
        self.lblName.text = self.attendee?.name
        self.lblBio.text = self.attendee?.about
        self.lblProfession.text = self.attendee?.profession
        self.lblEmail.text = self.attendee?.email
        UIImage.loadImageFrom(self.attendee?.profileImage?.fileURL) { (image) in
            dispatch_async(dispatch_get_main_queue(), {
                self.imvBackgroundImage.image = image
                self.imgAvatar.image = image
            })
        }
    }
    
    // MARK: UNWINDSEGUE
    @IBAction func unwindFromEdit(segue: UIStoryboardSegue){
        let editProfile = segue.sourceViewController as! EditProfile
        self.attendee = editProfile.attendee
        dispatch_async(dispatch_get_main_queue()) {
            self.configureView()
        }
    }
    
    // MARK: IBACTION
    @IBAction func editBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("goToEditProfileSegue", sender: self.attendee)
    }
    
    // MARK: NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nav = segue.destinationViewController as! UINavigationController
        let editVC = nav.viewControllers.first as! EditProfile
        editVC.attendee = sender as? Attendee
    }
}
