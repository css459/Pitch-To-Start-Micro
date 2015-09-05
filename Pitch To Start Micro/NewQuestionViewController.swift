//
//  NewQuestionViewController.swift
//  Pitch To Start Micro
//
//  Created by Cole Smith on 9/5/15.
//  Copyright (c) 2015 Cole Smith. All rights reserved.
//

import UIKit
import Firebase

class NewQuestionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var accessCode: UITextField!
    @IBOutlet weak var currentQuestion: UITextView!
    @IBOutlet weak var newQuestion: UITextView!
    @IBOutlet weak var voteCount: UILabel!
    
    let cm = CommunicationsManager()
    
    var eventEnded: Bool = false {
        willSet(newVal) {
            if newVal == true {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewControllerWithIdentifier("home") as! AccessCodeViewController
                presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessCode.delegate = self
        
        voteCount.text = "0"
        
        let votesRef = Firebase(url: "https://pitch-to-start-micro.firebaseio.com").childByAppendingPath("currentVoteCount")
        votesRef.observeEventType(.Value, withBlock: { (snapshot) in
            self.voteCount.text = String( snapshot.value as! Int )
        })
        
        let questionRef = Firebase(url: "https://pitch-to-start-micro.firebaseio.com").childByAppendingPath("currentQuestion")
        questionRef.observeEventType(.Value, withBlock: { (snapshot) in
            self.currentQuestion.text = snapshot.value as! String
        })
        
        let endEventRef = Firebase(url: "https://pitch-to-start-micro.firebaseio.com").childByAppendingPath("endEvent")
        endEventRef.observeEventType(.Value, withBlock: { (snapshot) in
            var isEndOfEvent = snapshot.value as! Bool
            self.eventEnded = isEndOfEvent
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if accessCode.text != "" {
            cm.uploadAccessKey(accessCode.text)
        }
        return false
    }
    
    @IBAction func endEventPressed(sender: AnyObject) {
        cm.endEvent()
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        cm.uploadQuestion(newQuestion.text, completion: { (success) in
            self.currentQuestion.text = self.cm.getQuestion()
            self.newQuestion.text = "Type A New Question Here"
        })
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        cm.storeQuestion()
    }
}
