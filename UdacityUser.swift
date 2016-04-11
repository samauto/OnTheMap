//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Sam Thomas on 4/1/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

// MARK: - Udacity User Data

struct UdacityUser {
    
    // MARK: Properties
    
    
    let uFirstname: String
    let uLastname: String
    
    let id: String
    let uLoc: String?
    let uLink: String?
    
    // MARK: Initializers
    
    // construct a ParseStudent from a dictionary
    init(dictionary: [String: AnyObject]) {
        uFirstname = (dictionary[UdacityClient.UData.ufirst] as? String)!
        uLastname = (dictionary[UdacityClient.UData.ulast] as? String)!
        uLink = dictionary[UdacityClient.UData.ulink] as? String!
        uLoc = dictionary[UdacityClient.UData.ulocation] as? String!
        id = (dictionary[UdacityClient.UData.ukey] as? String)!
    }
    
    static func userFromResults(results: [String:AnyObject]) -> [UdacityUser] {
        var user = [UdacityUser]()
        
            user.append(UdacityUser(dictionary: results))

        return user
    }
}



// MARK: - UdacityUser: Equatable

extension UdacityUser: Equatable {}

func ==(lhs: UdacityUser, rhs: UdacityUser) -> Bool {
    return lhs.id == rhs.id
}

