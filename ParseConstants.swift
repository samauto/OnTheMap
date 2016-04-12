//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/30/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

// MARK: - ParseClient (Constants)

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: Rest API Key
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Parse Application ID
        static let AppID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1"

        // MARK: Classes
        static let Classes = "/classes"
        static let ClassesStudentLocations = "/StudentLocation"
        static let ClassesUpdateStudentLocation = "/classes/StudentLocation/{id}"
 
        // MARK: URL
        static let ParseStudentLocationDataURL = ApiScheme+"://"+ApiHost+ApiPath+Classes+ClassesStudentLocations
        
        // MARK: Optional Paramaters
        static let limt = "limit=100"
        static let skip = "skip=400"
        static let order = "order=-updatedAt"
        
        static let ParseStudentLocationOptional = "?"+order
    }
    

    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
    }
    
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let StudentResults = "results"
        static let createdAt = "createdAt"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
    }
}
