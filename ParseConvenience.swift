//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/31/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit
import Foundation

// MARK: - ParseClient (Convenient Resource Methods)

extension ParseClient {
    
    // MARK: GET Convenience Methods
    
    // Get Student Locations
    func getStudentLocations(completionHandlerForStudents: (success: Bool, result: [ParseStudents]?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let meth: String = ParseClient.Constants.ParseStudentLocationDataURL
        let optpara: String = ParseClient.Constants.ParseStudentLocationOptional
        let mutableMethod: String = meth+optpara
    
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
    
    
    // POST Student Locations
    func postStudentLocations(JBody: [String:AnyObject], completionHandlerForStudents: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let mutableMethod: String = ParseClient.Constants.ParseStudentLocationDataURL
        
        
        /* 2. Make the request */
        taskForPOSTMethod(mutableMethod, jBody: JBody) { (success, result, error) in
            
            /* Send the desired value(s) to completion handler */
            guard (error == nil) else {
                completionHandlerForStudents(success: false, errorString: "Posting Student Location Failed.")
                return
            }

            if let error = error {
                completionHandlerForStudents(success: false, errorString: error)
            } else {
                
                completionHandlerForStudents(success: true, errorString: nil)
              }
        }
    }

    
    // UPDATE Student Locations
    func updateStudentLocations(ID: String, JBody: [String:AnyObject], completionHandlerForStudents: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let mutableMethod: String = ParseClient.Constants.ParseStudentLocationDataURL+"/"+ID
        
        /* 2. Make the request */
        taskForPUTMethod(mutableMethod, jBody: JBody) { (success, result, error) in

            /* Send the desired value(s) to completion handler */
            guard (error == nil) else {
                completionHandlerForStudents(success: false, errorString: "Updating Student Location Failed.")
                return
            }

            if let error = error {
                completionHandlerForStudents(success: false, errorString: error)
            } else {
                
                completionHandlerForStudents(success: true, errorString: nil)
            }
        }
    }

    
}
