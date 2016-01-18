//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/17/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: REST API Key
        static let RestApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Application ID
        static let ApplicationId : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        static let BaseURL : String = "http://api.parse.com/1/classes/"
        static let BaseURLSecure : String = "https://api.parse.com/1/classes/"
        
        // MARK: Other constants
        static let Limit = 100
        static let OrderBy = "updatedAt"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Student location
        static let StudentLocation : String = "StudentLocation"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        // MARK: Authentication
        static let ApiKey = "X-Parse-REST-API-Key"
        static let ApplicationId = "X-Parse-Application-Id"
        
        static let Limit = "limit"
        static let OrderBy = "order"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let Results = "results"
    }
    
}