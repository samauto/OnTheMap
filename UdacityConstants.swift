//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/30/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit

// MARK: - Udacity Constants

struct UConstants {
    
    // MARK: Api
    struct UdacityApi {
        static let Scheme = "https"
        static let Host = "www.udacity.com"
        static let Path = "/api"
        static let SignUp = "https://www.udacity.com/account/auth#!/signup"
        static let SessionPath = "/session"
        static let UserPath = "/users"
        static let UdacitySessionURL = Scheme+"://"+Host+Path+SessionPath
        static let UdacityUserURL = Scheme+"://"+Host+Path+UserPath
    }
    
    // MARK: Parameters
    struct UParameters {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    
    // MARK: Facebook
    struct UFacebook {
        static let FacebookAppID : String = "365362206864879"
    }
    
    // MARK: JSON Response Keys
    struct UResponseKeys {
        
        static let UserID = "key"
        static let SessionID = "id"
        static let IsRegistered = "registered"
        static let Expiration = "expiration"
    }
    
}

