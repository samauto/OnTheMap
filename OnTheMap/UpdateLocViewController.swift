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
    
    //Initializes
    var firstname: String!
    var lastname: String!
    var uid:String!
    var fName: String!
    var userLoc: String?
    var userLink: String?
    
    var searchName: String!
    var searchID: String!
    var searchCurrLoc: String!
    var searchURL: String!
    var searchFirst: String!
    var searchLast: String!
    var searchEdit: String! = "false"
    var searchLat: Double?
    var searchLong: Double?

    // MARK: Outlets

    @IBOutlet weak var LocNowInput: UITextField!
    @IBOutlet weak var FindOnMapButton: UIButton!
    @IBOutlet weak var CurrentMapView: MKMapView!
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserID: UILabel!
    @IBOutlet weak var UserCurrentLoc: UILabel!
    @IBOutlet weak var UserMediaURL: UILabel!
       
    @IBOutlet weak var MediaUrlLabel: UILabel!
    @IBOutlet weak var CurrentLocLabel: UILabel!
    
    @IBOutlet weak var botConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

        initializeTextFields()
        UserLocation()
        LocNowInput.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(UpdateLocViewController.dismissKey)))
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        //To retrieve keyboard size, uncomment following line
        //let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        botConstraint.constant = 260
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
   }
    
    func keyboardWillHide(notification: NSNotification) {
        //To retrieve keyboard size, uncomment following line
        //let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        botConstraint.constant = 20
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissKey() {
        LocNowInput.resignFirstResponder()
    }
    
    
    func initializeTextFields() {
        LocNowInput.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) ->Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UserLocation()
        
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 4
        let changeInHeight = (CGRectGetHeight(keyboardFrame) + 40) * (show ? 1 : -1)
        //5
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            self.botConstraint.constant += changeInHeight
        })
        
    }
    
    // FUNC: FindOpMap Pressed
    @IBAction func FinOnMapPressed(sender:AnyObject)
    {
        if LocNowInput.text == "" {
            popAlert("ERROR", errorString: "Location not entered!")
        } else {}
        
    }
    
    
    // FUNC: Prepare for Seque
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let usernewlocViewController: AddLocViewController = segue.destinationViewController as? AddLocViewController {
                 usernewlocViewController.searchName = self.UserName.text!
            usernewlocViewController.searchID = self.UserID.text!
            usernewlocViewController.searchCurrLoc = self.UserCurrentLoc.text!
            usernewlocViewController.searchLoc = self.LocNowInput.text!
            usernewlocViewController.searchURL = self.UserMediaURL.text!
            usernewlocViewController.searchFirst = self.searchFirst
            usernewlocViewController.searchLast = self.searchLast
            usernewlocViewController.searchEdit = self.searchEdit
            
        }
    }

    
    // FUNC: Cancel Button
    @IBAction func cancelbutton() {
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you want to Cancel", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: nil))
        
        let YESAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {
            (_)in
            self.performSegueWithIdentifier("unwindToMap", sender: self)
        })
        
        alert.addAction(YESAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // FUNC: UserLocations
    func UserLocation() {
        
        let editClicked = self.searchEdit!
        if (editClicked == "EDIT")
        {
            let localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = self.searchCurrLoc!
            let localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                
                if localSearchResponse == nil{
                    self.popAlert("ERROR",errorString: "Place Not Found")
                    return
                }
                
                let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                
                
                let userAnnotation = MKPointAnnotation()
                userAnnotation.title = self.searchName
                

                userAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.searchLat!, longitude: self.searchLong!)
                
                
                let pinAnnotationUser = MKPinAnnotationView(annotation: userAnnotation, reuseIdentifier: nil)
                self.CurrentMapView.centerCoordinate = userAnnotation.coordinate
                self.CurrentMapView.setRegion(MKCoordinateRegionMakeWithDistance(userAnnotation.coordinate, 2000, 2000), animated: true)
                self.CurrentMapView.addAnnotation(pinAnnotationUser.annotation!)
                
            }
            
            
            dispatch_async(dispatch_get_main_queue()) {                
                self.UserName.text = self.searchName!
                
                self.UserID.text = self.searchID!
                
                if (self.searchCurrLoc != nil) {
                    self.UserCurrentLoc.text = self.searchCurrLoc
                } else {
                    self.UserCurrentLoc.hidden = true
                    self.CurrentLocLabel.hidden = true
                }
                
                if (self.searchURL != nil) {
                    self.UserMediaURL.text = self.searchURL
                } else {
                    self.UserMediaURL.hidden = true
                    self.MediaUrlLabel.hidden = true
                }
            }

            
        }
        else {
        UdacityClient.sharedInstance().getUserLocations() {(success, results, errorString) in
            if(results != nil) {
                for dictionary in results! {
                    self.fName = dictionary.uFirstname+" "+dictionary.uLastname
                    self.searchFirst = dictionary.uFirstname
                    self.searchLast = dictionary.uLastname
                    self.uid = dictionary.id
                    self.userLoc = dictionary.uLoc
                    self.userLink = dictionary.uLink
                }
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.UserName.text = self.fName
                    
                    self.UserID.text = self.uid

                    if (self.userLoc != nil) {
                        self.UserCurrentLoc.text = self.userLoc
                    } else {
                        self.UserCurrentLoc.hidden = true
                        self.CurrentLocLabel.hidden = true
                      }
                    
                    if (self.userLink != nil) {
                        self.UserMediaURL.text = self.userLink
                    } else {
                        self.UserMediaURL.hidden = true
                        self.MediaUrlLabel.hidden = true
                      }
                }
            } else {
                self.popAlert("ERROR",errorString: "Unable to get student data. Please try again.")
              }
         }

      }
    }
    
    
    // Display an Alrt Box if there is an ERROR
    func popAlert(typeofalert:String, errorString: String) {
        let alertController = UIAlertController(title: typeofalert, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //FUNC unwindtoUpdateLoc
    @IBAction func unwindToUpdateLoc(segue: UIStoryboardSegue) {}


}