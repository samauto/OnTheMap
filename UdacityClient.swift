//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Mac on 3/30/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import Foundation

// MARK: - UdacityClient: NSObject

class UdacityClient : NSObject {

    // MARK: Properties
    
    // shared session
    var session = NSURLSession()
    
    // authentication state
    var sessionID: String? = nil
    var userID: String? = nil
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    // MARK: POST Session
    func UdacityLogin(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void ) {
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)

        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandler(success: false, errorString: "There was an error with your request: \(error)")
                return
            }
            
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandler(success: false, errorString: "Your request returned a status code other than 2xx!")
                return
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandler(success: false, errorString: "No data was returned by the request!")
                return
            }
            
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            //print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            var parsedResult: AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                completionHandler(success: false, errorString: "The response data could not be parsed")
                return
            }
            
            completionHandler(success: true, errorString: "")
            
            _ = ((parsedResult["account"] as! [String: AnyObject])["key"] as! String)
            _ = ((parsedResult["session"] as! [String:AnyObject])["id"]as! String)
    
        }
        
        task.resume()
    }

    
    // MARK: DELETE Session
    //func UdacityLogOut(completionHandler: (success: Bool, errorString: String?) -> Void ) {
        
   // let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
   // request.HTTPMethod = "DELETE"
   // var xsrfCookie: NSHTTPCookie? = nil
   // let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
   // for cookie in sharedCookieStorage.cookies! {
   //  if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
   // }
   // if let xsrfCookie = xsrfCookie {
   //     request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
   // }
   //
   // let task = session.dataTaskWithRequest(request) { data, response, error in
   //     if error != nil { // Handle error…
   //         return
   //     }
   //     let newData = data.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
   //     println(NSString(data: newData, encoding: NSUTF8StringEncoding))
   // }
   //
   //     task.resume()
    //}
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}