//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/30/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit

// Udacity Constants

extension UdacityClient {
    
    // Api
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
    
    // Parameters
    struct UParameters {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // Facebook
    struct UFacebook {
        static let FacebookAppID : String = "365362206864879"
    }
    
    // JSON Response Keys
    struct UResponseKeys {
        
        static let UserID = "key"
        static let SessionID = "id"
        static let IsRegistered = "registered"
        static let Expiration = "expiration"
    }
    
    // User
    struct UData {
        static let UserResults = "user"
        static let ufirst = "first_name"
        static let ulast = "last_name"
        static let ulocation = "location"
        static let ulink = "website_url"
        static let ukey = "key"
    }
    
    //AlERTS
    struct UAlerts {
        static let NetDown = "NETWORK FAILURE"
        static let NetDownMessage = "The Network is Down! Please try again later!"
        static let LoginDown = "LOGIN ERROR"
        static let LoginDownMessage = "Account does not exist for the username and password you entered!"
        static let FutDown = "COMING SOON"
        static let FutDownMessage = "This feature will be available in the Next Version"
    }

}

