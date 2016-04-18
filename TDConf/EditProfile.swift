//
//  EditProfile.swift
//  TDConf
//
//  Created by Rodrigo Leite on 18/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import UIKit

class EditProfile: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    
    // MARK: IBOutlet
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txvBio: UITextView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCamera.roundImage()
        imgProfile.roundImage()
        txvBio.delegate = self
        txtFieldName.delegate = self
        txtFieldEmail.delegate = self
    }
    
    // MARK: TEXTFIELD DELEGATE
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: TEXTVIEW DELEGATE
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: IBACTION
    @IBAction func btnDoneClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    
    @IBAction func btnCancelCliked(sender: AnyObject) {
        
    }
    
    
    @IBAction func btnCameraCliked(sender: UIButton) {
        
        
    }
    
    
    
}
