//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/12/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//
import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: Authentication (GET) Methods
    /*
    Steps for Authentication...
    https://www.themoviedb.org/documentation/api/sessions
    
    Step 1: Create a new request token
    Step 2a: Ask the user for permission via the website
    Step 3: Create a session ID
    Bonus Step: Go ahead and get the user id 😄!
    */
    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.getSessionID() { (success, sessionID, errorString) in
            
            if success {
                
                /* Success! We have the sessionID! */
                self.sessionID = sessionID
                
                self.getUserID() { (success, userID, errorString) in
                    
                    if success {
                        
                        if let userID = userID {
                            
                            /* And the userID 😄! */
                            self.userID = userID
                        }
                    }
                    
                    completionHandler(success: success, errorString: errorString)
                }
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func getSessionID(completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [UdacityClient.ParameterKeys.RequestToken : ""]
        
        /* 2. Make the request */
        taskForGETMethod(Methods.Session, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
            } else {
                if let sessionID = JSONResult[UdacityClient.JSONResponseKeys.SessionID] as? String {
                    completionHandler(success: true, sessionID: sessionID, errorString: nil)
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                    completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
                }
            }
        }
    }
    
    func getUserID(completionHandler: (success: Bool, userID: Int?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [UdacityClient.ParameterKeys.SessionID : UdacityClient.sharedInstance().sessionID!]
        
        /* 2. Make the request */
        taskForGETMethod(Methods.Account, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, userID: nil, errorString: "Login Failed (User ID).")
            } else {
                if let userID = JSONResult[UdacityClient.JSONResponseKeys.UserID] as? Int {
                    completionHandler(success: true, userID: userID, errorString: nil)
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.UserID) in \(JSONResult)")
                    completionHandler(success: false, userID: nil, errorString: "Login Failed (User ID).")
                }
            }
        }
    }
    
}
