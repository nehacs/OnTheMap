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
    
    // MARK: Login (POST) Methods

    func login(email: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        if email.isEmpty {
            completionHandler(success: false, errorString: "Username Empty.")
        } else if password.isEmpty {
            completionHandler(success: false, errorString: "Password Empty.")
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
            taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: jsonBody) { JSONResult, error, code in
                
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    var errorString = error
                    if code != 0 {
                        if (code == 403) {
                            errorString = "Invalid login credentials. Check your ID and password"
                        } else {
                            errorString = "Poor network connection. Please try again."
                        }
                    }
                    print(errorString)
                    completionHandler(success: false, errorString: errorString)
                } else {
                    // Get user ID
                    if let accountInfo = JSONResult[UdacityClient.JSONResponseKeys.Account] {
                        if let accountKey = accountInfo![UdacityClient.JSONResponseKeys.AccountKey] as? String {
                            UserData.userId = accountKey
                            completionHandler(success: true, errorString: nil)
                        } else {
                            let errorString = "Could not find \(UdacityClient.JSONResponseKeys.AccountKey) in \(JSONResult)"
                            print(errorString)
                            completionHandler(success: false, errorString: errorString)
                        }
                    } else {
                        let errorString = "Could not find \(UdacityClient.JSONResponseKeys.Account) in \(JSONResult)"
                        print(errorString)
                        completionHandler(success: false, errorString: errorString)
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
        taskForDELETEMethod(Methods.Session, parameters: parameters) { JSONResult, error, code in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Logout Failed.")
            } else {
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    // MARK: Get User Data (GET) Method
    func getUserData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        taskForGETMethod(Methods.Users, userId: UserData.userId) { JSONResult, error, code in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Failed to get user data.")
            } else {
                var wasSuccess:Bool = false
                // Get User Data
                if let userData = JSONResult[UdacityClient.JSONResponseKeys.User] {
                    // Get User ID
                    if let userId = userData![UdacityClient.JSONResponseKeys.UserId] as? String {
                        wasSuccess = true
                        UserData.userId = userId
                    } else {
                        wasSuccess = false
                        let errorString = "Could not find \(UdacityClient.JSONResponseKeys.UserId) in \(JSONResult)"
                        print(errorString)
                        completionHandler(success: false, errorString: errorString)
                    }
                    
                    // Get First Name
                    if let firstName = userData![UdacityClient.JSONResponseKeys.FirstName] as? String {
                        wasSuccess = true
                        UserData.firstName = firstName
                    } else {
                        wasSuccess = false
                        let errorString = "Could not find \(UdacityClient.JSONResponseKeys.FirstName) in \(JSONResult)"
                        print(errorString)
                        completionHandler(success: false, errorString: errorString)
                    }

                    // Get Last Name
                    if let lastName = userData![UdacityClient.JSONResponseKeys.LastName] as? String {
                        wasSuccess = true
                        UserData.lastName = lastName
                    } else {
                        wasSuccess = false
                        let errorString = "Could not find \(UdacityClient.JSONResponseKeys.UserId) in \(JSONResult)"
                        print(errorString)
                        completionHandler(success: false, errorString: errorString)
                    }
                    
                    if wasSuccess {
                        completionHandler(success: true, errorString: nil)
                    }
                    
                } else {
                    let errorString = "Could not find \(UdacityClient.JSONResponseKeys.User) in \(JSONResult)"
                    print(errorString)
                    completionHandler(success: false, errorString: errorString)
                }
            }
        }
    }
}
