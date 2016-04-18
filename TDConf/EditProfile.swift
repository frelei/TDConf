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
    @IBOutlet weak var btnProfileImg: UIButton!
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txvBio: UITextView!
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
}
