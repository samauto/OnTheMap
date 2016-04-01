//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/30/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import Foundation

// UdacityClient: NSObject

class UdacityClient : NSObject {

    // shared session
    var session = NSURLSession()
    
    // authentication state
    var SessID: String? = nil
    var UserID: String? = nil
    
    // MARK: Initializers
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    // POSTing (Creating a Session)
    func UdacityLogin(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void ) {
        
        let request = NSMutableURLRequest(URL: NSURL(string:UConstants.UdacityApi.UdacitySessionURL)!)

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
            
            //FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            var parsedResult: AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                completionHandler(success: false, errorString: "The response data could not be parsed")
                return
              }
            
            completionHandler(success: true, errorString: "")
            
            self.UserID = ((parsedResult["account"] as! [String: AnyObject])["key"] as! String)
            self.SessID = ((parsedResult["session"] as! [String:AnyObject])["id"]as! String)
    
            //print(AcctID, SessID)
        }
        
        task.resume()
    }

    
    // DELETEing (Logging Out Of) a Session
    func UdacityLogOut(completionHandler: (success: Bool, errorString: String?) -> Void ) {
        
        let request = NSMutableURLRequest(URL: NSURL(string:UConstants.UdacityApi.UdacitySessionURL)!)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
   
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
   
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

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            var parsedResult: AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                completionHandler(success: false, errorString: "The response data could not be parsed")
                return
            }
            
            completionHandler(success: true, errorString: "")
            
        }
   
        task.resume()
    }
    
    
    
    // GETting Public User Data
    func UdacityUserData(completionHandler: (success: Bool, results: [UdacityUser]?, errorString: String?) -> Void ) {
        
        let request = NSMutableURLRequest(URL: NSURL(string:UConstants.UdacityApi.UdacityUserURL+"/"+UserID!)!)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandler(success: false, results:nil, errorString: "There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandler(success: false, results:nil, errorString: "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandler(success: false, results:nil, errorString: "No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
            
            //completionHandler (success: true, result: parsedResult, errorString: "")
            
        }
        
        task.resume()
    }

    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (success: Bool, result: AnyObject!, errorString: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandlerForConvertData(success: false, result: nil, errorString: "Could not parse the data as JSON: '\(data)'")
        }
        completionHandlerForConvertData(success: true, result: parsedResult, errorString: nil)
    }
    
    
    // Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}