//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Sam Thomas on 4/1/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: GET Convenience Methods
    
    func getUserLocations(completionHandlerForUser: (success: Bool, result: [UdacityUser]?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let mutableMethod: String = UdacityClient.UdacityApi.UdacityUserURL+"/"+UserID!
        
        
        /* 2. Make the request */
        taskForGETUserMethod(mutableMethod) { (success, results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForUser(success: false, result: nil, errorString: error)
            } else {
                if let results = results[UdacityClient.UData.UserResults] as? [String:AnyObject] {
                
                    let users = UdacityUser.userFromResults(results)
                    
                    completionHandlerForUser(success: true, result: users, errorString: nil)
                } else {
                    completionHandlerForUser(success: false, result: nil, errorString: "Could not parse getUserData")
                  }
              }
        }
    }

}