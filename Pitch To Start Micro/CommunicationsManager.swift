//
//  CommunicationsManager.swift
//  Pitch To Start Micro
//
//  Created by Cole Smith on 9/5/15.
//  Copyright (c) 2015 Cole Smith. All rights reserved.
//

import UIKit
import Firebase

class CommunicationsManager: NSObject {
    
    let firebaseRef = Firebase(url: "https://pitch-to-start-micro.firebaseio.com")
    
    func checkAccessKey(key: String, completion: (isVerified: Bool, isMaster: Bool) -> ()) {
        let audienceAccessKey = firebaseRef.childByAppendingPath("audienceAccessKey")
        let masterAccessKey = firebaseRef.childByAppendingPath("masterAccessKey")
        
        audienceAccessKey.observeSingleEventOfType(.Value, withBlock: { (snapshotA) in
            masterAccessKey.observeSingleEventOfType(.Value, withBlock: { (snapshotM) in
                var audienceKey = snapshotA.value as! String
                var masterKey = snapshotM.value as! String
                
                if key == audienceKey {
                    completion(isVerified: true, isMaster: false)
                }
                else if key == masterKey {
                    completion(isVerified: true, isMaster: true)
                }
                else {
                    self.throwErrorMessage("Key not Valid", message: "The access key you entered was not valid, please try again")
                    completion(isVerified: false, isMaster: false)
                }
            })
        })
    }
    
    func uploadAccessKey(key: String) {
        let audienceKeyRef = firebaseRef.childByAppendingPath("audienceAccessKey")
        
        audienceKeyRef.setValue(key)
    }
    
    func uploadVote() {
        let currentVoteCountRef = firebaseRef.childByAppendingPath("currentVoteCount")
        
        currentVoteCountRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            currentVoteCountRef.runTransactionBlock({ (currentData) in
                var value = currentData.value as? Int
                if value == nil {
                    value = 0
                }
                currentData.value = value! + 1
                return FTransactionResult.successWithValue(currentData)
            })
        })
    }
    
    func getVotes() -> Int {
        let currentVoteCountRef = firebaseRef.childByAppendingPath("currentVoteCount")
        
        currentVoteCountRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            return snapshot.value as! Int
        })
        return 0
    }
    
    func uploadQuestion(question: String, completion: (success: Bool) -> ()) {
        let currentQuestionRef = firebaseRef.childByAppendingPath("currentQuestion")
        let currentVoteCountRef = firebaseRef.childByAppendingPath("currentVoteCount")
        
        currentQuestionRef.setValue(question)
        currentVoteCountRef.setValue(0)
        
        completion(success: true)
    }
    
    func getQuestion() -> String {
        let currentQuestionRef = firebaseRef.childByAppendingPath("currentQuestion")
        
        currentQuestionRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            return snapshot.value as! String
        })
        return ""
    }
    
    func storeQuestion() {
        let currentVoteCountRef = firebaseRef.childByAppendingPath("currentVoteCount")
        let currentQuestionRef = firebaseRef.childByAppendingPath("currentQuestion")
        let questionsRef = firebaseRef.childByAppendingPath("questions")
        
        currentQuestionRef.observeSingleEventOfType(.Value, withBlock: { (snapshotQ) in
            currentVoteCountRef.observeSingleEventOfType(.Value, withBlock: { (snapshotV) in
                var question = snapshotQ.value as? String
                var votes = snapshotV.value as? Int
                
                let newQuestion = questionsRef.childByAppendingPath(question)
                newQuestion.setValue(votes)
            })
        })
    }
    
    func endEvent() {
        let endRef = firebaseRef.childByAppendingPath("endEvent")
        let currentVoteCountRef = firebaseRef.childByAppendingPath("currentVoteCount")
        let currentQuestionRef = firebaseRef.childByAppendingPath("currentQuestion")
        
        
        currentVoteCountRef.setValue(0)
        currentQuestionRef.setValue("Please Wait For The Next Question")
        endRef.setValue(true)
        endRef.setValue(false)
    }
    
    func throwErrorMessage(title: String, message: String) {
        var alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.delegate = self
        alert.addButtonWithTitle("OK")
        alert.show()
    }

}
