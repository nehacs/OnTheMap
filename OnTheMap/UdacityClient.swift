//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/10/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation

// MARK: - UdacityClient: NSObject

class UdacityClient: NSObject {
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession

    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    // MARK: GET
    
    func taskForGETMethod(method: String, userId: String, completionHandler: (result: AnyObject!, error: String?, code: Int) -> Void) -> NSURLSessionDataTask {
        /* Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + "/" + userId
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "GET"
        
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
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: String?, code: Int) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        let mutableParameters = parameters
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + UdacityClient.escapedParameters(mutableParameters)
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }

        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            var code = 0
            var errorString = ""
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                errorString = "There was an error with your request: \(error)"
                print(errorString)
                completionHandler(result: nil, error: errorString, code: code)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    code = response.statusCode
                    errorString = "Your request returned an invalid response! Status code: \(response.statusCode)!"
                    print(errorString)
                } else if let response = response {
                    code = 0
                    errorString = "Your request returned an invalid response! Response: \(response)!"
                    print(errorString)
                } else {
                    code = 0
                    errorString = "Your request returned an invalid response!"
                    print(errorString)
                }
                completionHandler(result: nil, error: errorString, code: code)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    
    func taskForDELETEMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: String?, code: Int) -> Void) -> NSURLSessionDataTask {
        /* 1. Set the parameters */
        let mutableParameters = parameters
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + UdacityClient.escapedParameters(mutableParameters)
        
        /* 4. Make the request */
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
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
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: String?, code: Int) -> Void) {
        
        let range = NSMakeRange(5, data.length)
        let trimmed_data = NSData(data: data.subdataWithRange(range))
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(trimmed_data, options: .AllowFragments)
        } catch {
            completionHandler(result: nil, error: "Could not parse the data as JSON: '\(data)'", code: 1)
        }
        
        completionHandler(result: parsedResult, error: nil, code: 0)
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
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}