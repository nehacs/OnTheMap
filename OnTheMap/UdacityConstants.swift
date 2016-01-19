//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/12/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let BaseURL : String = "http://www.udacity.com/api/"
        static let BaseURLSecure : String = "https://www.udacity.com/api/"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Users = "users"
        
        // MARK: Config
        static let Config = "configuration"
        
        // MARK: Session
        static let Session = "session"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let Session = "session"
        static let SessionID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: Account
        static let Account = "account"
        static let AccountKey = "key"
        
        // MARK: UserData
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let UserId = "key"
        
    }
    
    // MARK: Poster Sizes
    struct PosterSizes {
        
//        static let RowPoster = UdacityClient.sharedInstance().config.posterSizes[2]
//        static let DetailPoster = UdacityClient.sharedInstance().config.posterSizes[4]
        
    }
}