//
//  AudienceQuestionViewController.swift
//  Pitch To Start Micro
//
//  Created by Cole Smith on 9/5/15.
//  Copyright (c) 2015 Cole Smith. All rights reserved.
//

import UIKit
import Firebase

class AudienceQuestionViewController: UIViewController {
    
    @IBOutlet weak var question: UILabel!
    
    let cm = CommunicationsManager()
    
    var rightSwipe:UISwipeGestureRecognizer!
    var leftSwipe: UISwipeGestureRecognizer!

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
        
        rightSwipe = UISwipeGestureRecognizer(target: self, action: "didSwipeRight")
        leftSwipe  = UISwipeGestureRecognizer(target: self, action: "didSwipeLeft")
        
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
        
        let questionRef = Firebase(url: "https://pitch-to-start-micro.firebaseio.com").childByAppendingPath("currentQuestion")
        questionRef.observeEventType(.Value, withBlock: { (snapshot) in
            var questionFromFB = snapshot.value as! String
            self.question.text = questionFromFB
            
            self.leftSwipe.enabled = true
            self.rightSwipe.enabled = true
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
    
    func didSwipeLeft() {
        self.flashView(false)
    }
    
    func didSwipeRight() {
        self.flashView(true)
        self.cm.uploadVote()
    }
    
    func flashView(answer: Bool) {
        if let wnd = self.view{
            
            var v = UIView(frame: wnd.bounds)
            
            if answer {
                v.backgroundColor = color_orange
            }
            else {
                v.backgroundColor = color_lightBlue
            }
            
            v.alpha = 1
            
            wnd.addSubview(v)
            UIView.animateWithDuration(1, animations: {
                
                v.alpha = 0.0
                
                self.question.text = "Please wait for the next question"
                self.rightSwipe.enabled = false
                self.leftSwipe.enabled = false
                
                }, completion: {(finished:Bool) in
                    println("inside")
                    v.removeFromSuperview()
            })
        }
    }

}
