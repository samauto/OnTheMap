//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/26/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
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
        initializeTextFields()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Get the shared URL Session
        session = NSURLSession.sharedSession()
  
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(LoginViewController.dismissKey)))
    }
    
    func dismissKey() {
        emailTextInput.resignFirstResponder()
        passwordTextInput.resignFirstResponder()
    }
    
    
    func initializeTextFields() {
        emailTextInput.delegate = self
        passwordTextInput.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) ->Bool {
        textField.resignFirstResponder()
        return true
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
                        
                        if (errorString == "Account Invalid") {
                            self.loginStatement.text="User not registered please sign up!"
                            self.popAlert(UdacityClient.UAlerts.LoginDown, errorString: UdacityClient.UAlerts.LoginDownMessage)
                            return
                        }
                        else if (errorString == "Account Valid") {
                            self.completeLogin()
                        }
                    } else {
                        self.loginStatement.text="Network is Down"
                        self.popAlert(UdacityClient.UAlerts.NetDown, errorString: UdacityClient.UAlerts.NetDownMessage)
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
        popAlert(UdacityClient.UAlerts.FutDown , errorString:"")
    }

    //FUNC: popAlert(): Display an Alrt Box
    func popAlert(typeOfAlert: String, errorString: String) {
        let alertController = UIAlertController(title: typeOfAlert, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
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







