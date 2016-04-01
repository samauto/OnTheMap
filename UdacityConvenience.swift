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
    
    func getStudentLocations(completionHandlerForStudents: (success: Bool, result: [UdacityUser]?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let mutableMethod: String = ParseClient.Constants.ParseStudentLocationDataURL
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod) { (success, results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudents(success: false, result: nil, errorString: error)
            } else {
                
                if let results = results[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                    
                    let students = ParseStudents.studentsFromResults(results)
                    
                    completionHandlerForStudents(success: true, result: students, errorString: nil)
                } else {
                    completionHandlerForStudents(success: false, result: nil, errorString: "Could not parse getStudentLocations")
                }
            }
        }
    }
    
    
}

