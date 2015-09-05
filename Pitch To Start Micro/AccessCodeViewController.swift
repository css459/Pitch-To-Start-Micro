//
//  AccessCodeViewController.swift
//  Pitch To Start Micro
//
//  Created by Cole Smith on 9/5/15.
//  Copyright (c) 2015 Cole Smith. All rights reserved.
//

import UIKit

class AccessCodeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var accessCode: UITextField!
    
    let cm = CommunicationsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessCode.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        cm.checkAccessKey(accessCode.text, completion: { (isVerified, isMaster) in
            if isVerified && isMaster {
                // Segue to Master
                self.performSegueWithIdentifier("master", sender: nil)
            }
            else if isVerified && !isMaster {
                // Segue to Audience
                self.performSegueWithIdentifier("audience", sender: nil)
            }
            else {
                println("Access Code not valid")
            }
        })
    }
}
