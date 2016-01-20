//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/17/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation

// MARK: - ParseClient: NSObject

class ParseClient: NSObject {
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* Set the parameters */
        var mutableParameters = parameters
        mutableParameters[ParameterKeys.Limit] = Constants.Limit
        mutableParameters[ParameterKeys.OrderBy] = Constants.OrderBy
        
        /* Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(mutableParameters)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "GET"
        request.addValue(Constants.RestApiKey, forHTTPHeaderField: ParameterKeys.ApiKey)
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: ParameterKeys.ApplicationId)
        
        /* Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* Set the parameters */
        let mutableParameters = parameters
        
        /* Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(mutableParameters)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.RestApiKey, forHTTPHeaderField: ParameterKeys.ApiKey)
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: ParameterKeys.ApplicationId)
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}
