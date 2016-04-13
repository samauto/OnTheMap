//
//  Students.swift
//  OnTheMap
//
//  Created by Mac on 4/12/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import Foundation

class Students {
    
    var studentsloc: [ParseStudents] = [ParseStudents]()
    //Initializes the Students Variable that will be used to populate the List
    
    class func sharedInstance() -> Students {
        struct Singleton {
            static var sharedInstance = Students()
        }
        
        return Singleton.sharedInstance
    }
    
}