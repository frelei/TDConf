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
    @IBOutlet var btnTopLeft: UIButton!
    @IBOutlet var viewBottomGradient: UIView!
    @IBOutlet var viewTopGradient: UIView!
    
    var gl: CAGradientLayer?
    var tabBatDefaultColor: UIColor?
    
    
    var attendee: Attendee?
    
    func setBtnTopLeftText(text :String) -> Void {
//        let font = UIFont.systemFontOfSize(22.0)
//        let attribs = [
//            NSForegroundColorAttributeName: UIColor.whiteColor(),
//            NSStrokeColorAttributeName: UIColor.whiteColor(),
//            NSFontAttributeName: font,
//            NSStrokeWidthAttributeName: 2.0
//        ]
//        
//        let formattedText = NSAttributedString(string: "\(text)", attributes: attribs)
        self.btnTopLeft.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnTopLeft.setTitle(text, forState: UIControlState.Normal)

    }
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBatDefaultColor = self.tabBarController?.tabBar.barTintColor;
        self.imgAvatar.roundImage()
        self.loadAtendee()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.barTintColor = self.tabBatDefaultColor
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.tabBar.barTintColor = UIColor.blackColor()

        if self.gl == nil {
            
            let colorTop = UIColor.clearColor().CGColor
            let colorBottom = UIColor.blackColor().CGColor
            
            self.gl = CAGradientLayer()
            self.gl!.frame = self.viewTopGradient.frame
            self.gl!.colors = [ colorTop, colorBottom]
            self.gl!.locations = [ 0.0, 1.0]
            self.viewTopGradient.layer.addSublayer(self.gl!)
        }
        
    }
    
    // MARK: Load Data
    func loadAtendee() {
        self.btnTopLeft.enabled = false
        if self.attendee == nil {
            self.setBtnTopLeftText("Edit")
            Attendee.attendeeUser { (result, error) in
                if error == nil && result != nil {
                    self.attendee = result
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.stopAnimating()
                        self.configureView()
                        self.btnTryAgain.hidden = true
                        self.btnTopLeft.enabled = true
                    })
                } else if result == nil && error == nil {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.btnTryAgain.hidden = true
                    self.editButtonItem().enabled = true
                    self.performSegueWithIdentifier("goToEditProfileSegue", sender: self.attendee)
                } else {
                    self.btnTryAgain.hidden = false;
                    self.lblName.text = "";
                    self.lblProfession.text = "";
                    self.lblEmail.text = "";
                    self.lblBio.text = "An error happened. Please try again later"
                }
            }
        } else {
            self.activityIndicator.stopAnimating()
            self.setBtnTopLeftText("Done")
            self.btnTopLeft.enabled = true;
            self.configureView()
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
                self.imgAvatar.contentMode = .ScaleAspectFill
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
        if self.btnTopLeft.titleLabel?.text == "Done" {
            self.dismissViewControllerAnimated(true, completion: nil);
        } else {
            self.performSegueWithIdentifier("goToEditProfileSegue", sender: self.attendee)
        }
    }
    
    // MARK: NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nav = segue.destinationViewController as! UINavigationController
        let editVC = nav.viewControllers.first as! EditProfile
        editVC.attendee = sender as? Attendee
    }
}
