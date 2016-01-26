//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/17/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation
import MapKit

extension ParseClient {
 
    // MARK: GetLocations (GET) Method
    
    func getLocations(completionHandler: (success: Bool, locations: [[String: AnyObject]], errorString: String?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        
        /* 2. Make the request */
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { JSONResult, success, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if success {
                if let results = JSONResult[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    completionHandler(success: true, locations: results, errorString: nil)
                } else {
                    print("Could not find \(ParseClient.JSONResponseKeys.Results) in \(JSONResult)")
                    completionHandler(success: false, locations: [], errorString: "Could not get results.")
                }
            } else {
                print(error)
                completionHandler(success: false, locations: [], errorString: "Request Failed.")
            }
        }
    }

    func postStudentLocation(userId: String, firstName: String, lastName: String, mediaURL: String, mapString: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapString, completionHandler: {(placemarks, error) -> Void in
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                let latitude = coordinates.latitude
                let longitude = coordinates.longitude
                let jsonBody : [String:AnyObject] = [
                    ParseClient.JSONBodyKeys.UniqueKey: userId,
                    ParseClient.JSONBodyKeys.FirstName: firstName,
                    ParseClient.JSONBodyKeys.LastName: lastName,
                    ParseClient.JSONBodyKeys.Latitude: latitude,
                    ParseClient.JSONBodyKeys.Longitude: longitude,
                    ParseClient.JSONBodyKeys.MapString: mapString,
                    ParseClient.JSONBodyKeys.MediaURL: mediaURL
                ]
                
                /* 2. Make the request */
                self.taskForPOSTMethod(Methods.StudentLocation, parameters: parameters, jsonBody: jsonBody) { JSONResult, success, error in
                    
                    /* 3. Send the desired value(s) to completion handler */
                    completionHandler(success: success, errorString: error)
                }
            }
        })
    }
}