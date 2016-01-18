//
//  Location.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/17/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation

// MARK: - Location

struct Location {
    
    // MARK: Properties
    var firstName = ""
    var lastName = ""
    var link = ""

    init(dictionary: [String: AnyObject]) {
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        link = dictionary["mediaURL"] as! String
    }
    
    static func locationsFromResults(results: [[String : AnyObject]]) -> [Location] {
        
        var locations = [Location]()
        
        /* Iterate through array of dictionaries; each Movie is a dictionary */
        for result in results {
            locations.append(Location(dictionary: result))
        }
        
        return locations
    }
}