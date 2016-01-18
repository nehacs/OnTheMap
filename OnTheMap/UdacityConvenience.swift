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
    
    // MARK: Authentication/Login (POST) Methods

    func authenticateWithViewController(hostViewController: LoginViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.login(hostViewController.emailTextField.text!, password: hostViewController.passwordTextField.text!) { (success, sessionID, errorString) in
            
            if success {
                
                /* Success! We have the sessionID! */
                self.sessionID = sessionID
                
                completionHandler(success: success, errorString: errorString)
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func login(email: String, password: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        if email.isEmpty {
            completionHandler(success: false, sessionID: nil, errorString: "Username Empty.")
        } else if password.isEmpty {
            completionHandler(success: false, sessionID: nil, errorString: "Password Empty.")
        } else {
            
            
            /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
            let parameters = [String: AnyObject]()
            
            let jsonBody : [String:AnyObject] = [
                UdacityClient.JSONBodyKeys.Udacity: [
                    UdacityClient.JSONBodyKeys.Username: email,
                    UdacityClient.JSONBodyKeys.Password: password
                ]
            ]
            
            /* 2. Make the request */
            taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
                
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    print(error)
                    completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
                } else {
                    if let sessionInfo = JSONResult[UdacityClient.JSONResponseKeys.Session] {
                        if let sessionID = sessionInfo![UdacityClient.JSONResponseKeys.SessionID] as? String {
                            completionHandler(success: true, sessionID: sessionID, errorString: nil)
                        } else {
                            print("Could not find \(UdacityClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                            completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
                        }
                    } else {
                        print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(JSONResult)")
                        completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
                    }
                }
            }
        }
    }
    
    // MARK: Logout (DELETE) Method
    
    func logout(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        
        /* 2. Make the request */
        taskForDELETEMethod(Methods.Session, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Logout Failed.")
            } else {
                completionHandler(success: true, errorString: nil)
            }
        }
    }
}
