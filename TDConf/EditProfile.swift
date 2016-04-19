//
//  EditProfile.swift
//  TDConf
//
//  Created by Rodrigo Leite on 18/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit
import CloudKit

class EditProfile: UITableViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: IBOutlet
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txvBio: UITextView!
    @IBOutlet weak var txtProfession: UITextField!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var attendee: Attendee?
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCamera.roundImage()
        imgProfile.roundImage()
        txvBio.delegate = self
        txtFieldName.delegate = self
        txtFieldEmail.delegate = self
        txtProfession.delegate = self
        self.configure()
    }
    
    func configure(){
        if let attending = attendee{
            self.txtFieldEmail.text = attending.email
            self.txvBio.text = attending.about
            self.txtFieldName.text = attending.name
            UIImage.loadImageFrom(attending.profileImage?.fileURL, completion: { (image) in
                dispatch_async(dispatch_get_main_queue(), { 
                    self.imgProfile.image = image
                })
            })
        }else{
            self.attendee = Attendee(recordType: "Attendee")
        }
    }
    
    // MARK: TEXTFIELD DELEGATE
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - UIPIKERVIEWCONTROLLER
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = pickerImage{
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
            let localPath = documentDirectory + "/profilePicture"
            let data = UIImagePNGRepresentation(pickerImage!)
            data!.writeToFile(localPath, atomically: true)
            let photoURL = NSURL(fileURLWithPath: localPath)
            let asset = CKAsset(fileURL: photoURL)
            self.attendee?.profileImage = asset
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.imgProfile.image = image
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: IBACTION
    @IBAction func btnDoneClicked(sender: AnyObject) {
        if (!self.txtFieldName.text!.isEmpty &&
            !self.txtFieldEmail.text!.isEmpty &&
            !self.txvBio.text.isEmpty &&
            !self.txtProfession.text!.isEmpty){
            KBCloudKit.container().fetchUserRecordIDWithCompletionHandler({ (recordID, error) in
                let reference = CKReference(recordID: recordID!, action: .DeleteSelf)
                self.attendee?.userReference = reference
                self.attendee?.name = self.txtFieldName.text
                self.attendee?.email = self.txtFieldEmail.text
                self.attendee?.about = self.txvBio.text
                self.attendee?.profession = self.txtProfession.text
                KBCloudKit.dataBaseFromContainer(type: .PUBLIC).saveRecord(self.attendee!.record!, completionHandler: { (record, error) in
                    if error == nil{
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }else{
                        Logging(error?.description)
                        let alertController = UIAlertController.showBasicAlertMessage("Occour an error on server", title: "Whoops!!!")
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                })
            })
        }
        else{
            let alertController = UIAlertController.showBasicAlertMessage("Fill all the fields", title: "Whoops!!!")
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnCancelCliked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func btnCameraCliked(sender: UIButton) {
        let alertController = UIAlertController(title: "Choose an option", message: "", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Take profile photo", style: .Default) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.Camera){
                let pickerController = UIImagePickerController()
                pickerController.allowsEditing = true
                pickerController.sourceType = .Camera
                pickerController.cameraCaptureMode = .Photo
                pickerController.delegate = self
                self.presentViewController(pickerController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController.showBasicAlertMessage("No camera found on device", title: "")
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        let albumAction = UIAlertAction(title: "Choose from library", style: .Default) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                let pickerController = UIImagePickerController()
                pickerController.allowsEditing = true
                pickerController.sourceType = .PhotoLibrary
                pickerController.delegate = self
                self.presentViewController(pickerController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController.showBasicAlertMessage("No album on device", title: "")
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
