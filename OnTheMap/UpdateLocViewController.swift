//
//  UpdateLocViewController.swift
//  OnTheMap
//
//  Created by Sam Thomas on 4/4/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UpdateLocViewController: UIViewController, UITextFieldDelegate {
    
    var firstname: String!
    var lastname: String!

    // MARK: Outlets

    @IBOutlet weak var LocNowInput: UITextField!
    @IBOutlet weak var FindOnMapButton: UIButton!
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserID: UILabel!
    @IBOutlet weak var UserCurrentLoc: UILabel!
    @IBOutlet weak var UserMediaURL: UILabel!
    @IBOutlet weak var currentMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserLocation()
        LocNowInput.delegate = self
        self.LocNowInput.text = "Houston, TX"
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UserLocation()
        
    }
    
    
    @IBAction  func FinOnMapPressed(sender:AnyObject)
    {
        if LocNowInput.text == "" {
            errorAlert("Location not entered!")
        } else {}
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let usernewlocViewController: AddLocViewController = segue.destinationViewController as? AddLocViewController {
            usernewlocViewController.searchLoc = self.LocNowInput.text!
            usernewlocViewController.searchName = self.UserName.text!
            usernewlocViewController.searchID = self.UserID.text!
            usernewlocViewController.searchCurrLoc = self.UserCurrentLoc.text!
            usernewlocViewController.searchURL = self.UserMediaURL.text!
            
            usernewlocViewController.searchFirst = self.firstname
            usernewlocViewController.searchLast = self.lastname
            
        }
    }

    
    func UserLocation() {
        UdacityClient.sharedInstance().getUserLocations() {(success, results, errorString) in
            if(results != nil) {
                self.firstname = results![UdacityClient.UData.ufirst] as? String
                self.lastname = results![UdacityClient.UData.ulast] as? String
                let userid = results![UdacityClient.UData.ukey] as? String
                let userloc = results![UdacityClient.UData.ulocation] as? String
                let userURL = results![UdacityClient.UData.ulink] as? String
                
                let fullName: String = self.firstname!+" "+self.lastname!
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.UserName.text = fullName
                    
                    self.UserID.text = userid
                    
                    if (userloc == "") {
                        self.UserCurrentLoc.text = userloc
                    } else {
                        self.UserCurrentLoc.text = "None Selected"
                      }
                    
                    if (userURL == "") {
                        self.UserMediaURL.text = userURL
                    } else {
                        self.UserMediaURL.text = "None Selected"
                      }
                }
            } else {
                self.errorAlert("Unable to get student data. Please try again.")
              }
         }

    }
    
    
    // Display an Alrt Box if there is an ERROR
    func errorAlert(errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }


}