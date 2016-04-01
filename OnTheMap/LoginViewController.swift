//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/26/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    // MARK: Outlets
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var loginStatement: UILabel!
    
    var appDelegate: AppDelegate!
    
    var session: NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        emailTextInput.text = "samauto@gmail.com"
        passwordTextInput.text = "Iris88erin"
        
        //Get the shared URL Session
        session = NSURLSession.sharedSession()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loginStatement.text = ""
    }
    
    
    // When Login is Successful
    func completeLogin() {
        performUIUpdatesOnMain {
            self.loginStatement.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    
    // Login to Udacity
    @IBAction func loginPressed(sender: AnyObject) {
        if (emailTextInput.text!.isEmpty || passwordTextInput.text!.isEmpty) {
            loginStatement.text = "Username and/or Password Empty!"
        } else {
            let username = emailTextInput.text
            let password = passwordTextInput.text

            UdacityClient.sharedInstance().UdacityLogin(username!, password:password!)
            { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.loginStatement.text="User not registered please sign up!"
                      }
                }
                
            }
          }
    }
    
    
    // SignUp to Udacity
    @IBAction func signUp (sender: AnyObject) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup"){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    // Login via Facebook to Udacity
    @IBAction func facebookPressed(sender:AnyObject) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"DADFMS4SN9e8BAD6vMs6yWuEcrJlMZChFB0ZB0PCLZBY8FPFYxIPy1WOr402QurYWm7hj1ZCoeoXhAk2tekZBIddkYLAtwQ7PuTPGSERwH1DfZC5XSef3TQy1pyuAPBp5JJ364uFuGw6EDaxPZBIZBLg192U8vL7mZAzYUSJsZA8NxcqQgZCKdK4ZBA2l2ZA6Y1ZBWHifSM0slybL9xJm3ZBbTXSBZCMItjnZBH25irLhIvbxj01QmlKKP3iOnl8Ey;\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Handle error...
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            self.completeLogin()
        }
        
        task.resume()
    }

}


// LoginViewController (UI)
extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        emailTextInput.enabled = enabled
        passwordTextInput.enabled = enabled
        loginButton.enabled = enabled
        loginStatement.text = ""
        loginStatement.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
          }
    }

}







