//
//  Location.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/17/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation

// MARK: - StudentInformation

struct StudentInformation {
    
    // MARK: Properties
    var firstName = ""
    var lastName = ""
    var link = ""
    var latitude = 0.0
    var longitude = 0.0

    init(dictionary: [String: AnyObject]) {
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        link = dictionary["mediaURL"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
    }
    
    static func studentsFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        /* Iterate through array of dictionaries; each Movie is a dictionary */
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
}