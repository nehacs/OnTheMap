//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/17/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation

extension ParseClient {
 
    // MARK: GetLocations (GET) Method
    
    func getLocations(completionHandler: (success: Bool, locations: [[String: AnyObject]], errorString: String?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        
        /* 2. Make the request */
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, locations: [], errorString: "Request Failed.")
            } else {
                if let results = JSONResult[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    completionHandler(success: true, locations: results, errorString: nil)
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                    completionHandler(success: false, locations: [], errorString: "Login Failed (Session ID).")
                }
            }
        }
    }

}