//
//  ParseStudents.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/31/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//


// MARK: - Parse Students

struct ParseStudents {
    
    // MARK: Properties
    
    
    let firstname: String
    let lastname: String
    
    let Loc: String
    let Link: String
    let id: String
    let lat: Double
    let long: Double

    
    // MARK: Initializers
    
    // construct a ParseStudent from a dictionary
    init(dictionary: [String:AnyObject]) {
        firstname = dictionary[ParseClient.JSONResponseKeys.firstName] as! String
        lastname = dictionary[ParseClient.JSONResponseKeys.lastName] as! String
        Link = (dictionary[ParseClient.JSONResponseKeys.mediaURL] as? String)!
        Loc = (dictionary[ParseClient.JSONResponseKeys.mapString] as? String)!
        id = (dictionary[ParseClient.JSONResponseKeys.objectId] as? String)!
        lat = (dictionary[ParseClient.JSONResponseKeys.latitude] as? Double)!
        long = (dictionary[ParseClient.JSONResponseKeys.longitude] as? Double)!
    }
    
    static var StudentArray : [ParseStudents] = []
    
    static func studentsFromResults(results: [[String:AnyObject]]) -> [ParseStudents] {
        
        var students = [ParseStudents]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            students.append(ParseStudents(dictionary: result))
        }
        
        return students
    }
}



// MARK: - ParseStudents: Equatable

extension ParseStudents: Equatable {}

func ==(lhs: ParseStudents, rhs: ParseStudents) -> Bool {
    return lhs.id == rhs.id
}
