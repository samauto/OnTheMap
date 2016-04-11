//
//  AddLocViewController.swift
//  OnTheMap
//
//  Created by Mac on 4/4/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit
import MapKit

class AddLocViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var SearchLocName: UILabel!
    @IBOutlet weak var OldLocation: UILabel!
    @IBOutlet weak var OldLink: UILabel!
    @IBOutlet weak var NewLinkInput: UITextField!
    
    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var OldLocLabel: UILabel!
    
    //Initializes
    var searchLoc:String?
    var searchName: String?
    var searchID: String?
    var searchCurrLoc: String!
    var searchURL: String!
    var searchFirst: String!
    var searchLast: String!
    var searchEdit: String!

    var lat:Double?
    var long:Double?
    
    
    // FUNC: Display an Alrt Box if there is an ERROR
    func popAlert(typeofalert:String, errorString: String) {
        let alertController = UIAlertController(title: typeofalert, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchForLocation()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        SearchForLocation()
    }

    
    // FUNC: Search For Locations
    func SearchForLocation() {
        
        SearchLocName.text = self.searchLoc
        OldLocation.text = self.searchCurrLoc
        OldLink.text = self.searchURL
        formatLabel.text = "(ex.http://www.example.com)"
        
        if (OldLocation.text == "Location") {
            OldLocation.hidden = true
            OldLocLabel.hidden = true}
                
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchLoc
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                self.popAlert("ERROR",errorString: "Place Not Found")
                return
            }
            
            let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
            
            let userAnnotation = MKPointAnnotation()
            userAnnotation.title = self.searchName
            
            self.lat = localSearchResponse!.boundingRegion.center.latitude
            self.long = localSearchResponse!.boundingRegion.center.longitude
            
            userAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            let pinAnnotationUser = MKPinAnnotationView(annotation: userAnnotation, reuseIdentifier: nil)
            self.MapView.centerCoordinate = userAnnotation.coordinate
            self.MapView.setRegion(MKCoordinateRegionMakeWithDistance(userAnnotation.coordinate, 2000, 2000), animated: true)
            self.MapView.addAnnotation(pinAnnotationUser.annotation!)
            
        }
    }
    
    
    // FUNC: Checks if the URL is valid or not
    func validUrlChk (URLinput: String?) -> Bool {
        if URLinput != nil {
            if let URLinput = NSURL(string: URLinput!) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(URLinput)
            }
        }
        return false
    }

    
    // FUNC: BACK BUTTON
    @IBAction func backbutton() {
        self.performSegueWithIdentifier("unwindToUpdateLoc", sender: self)
    }

    
    // FUNC: CANCEL BUTTON
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

    // FUNC: SUBMIT BUTTON
    @IBAction func submitLocation() {
        
        let editClicked = self.searchEdit
        var jsonBody:[String:AnyObject] = [:]
        
            if (validUrlChk (NewLinkInput.text!) == false) {
                popAlert("ERROR",errorString: "Invalid Link please use format (http://www.example.com), etc")
                return
            }
            else {
                if (editClicked == "EDIT") {
                    jsonBody = [
                    ParseClient.JSONResponseKeys.uniqueKey: "\(self.searchID!)",
                    ParseClient.JSONResponseKeys.firstName: "\(self.searchFirst!)",
                    ParseClient.JSONResponseKeys.lastName: "\(self.searchLast!)",
                    ParseClient.JSONResponseKeys.mapString: "\(self.searchLoc!)",
                    //ParseClient.JSONResponseKeys.mediaURL: "\(self.searchURL!)",
                    ParseClient.JSONResponseKeys.mediaURL: "\(NewLinkInput.text!)",
                    ParseClient.JSONResponseKeys.latitude: self.lat!,
                    ParseClient.JSONResponseKeys.longitude: self.long!]
                    
                    ParseClient.sharedInstance().updateStudentLocations(self.searchID!, JBody:jsonBody){ (success, errorString) in
                        if(success) {
                            // "Successfully updated location")
                            dispatch_async(dispatch_get_main_queue()) {
                                let alert = UIAlertController(title: "Student Location", message: "Location Updated Sucessfully!", preferredStyle: .Alert)
                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                                    (_)in
                                    self.performSegueWithIdentifier("unwindToMap", sender: self)
                                })
                                
                                alert.addAction(OKAction)
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        } else {
                            // "Location submission errored out")
                            dispatch_async(dispatch_get_main_queue()) {
                                self.popAlert("ERROR", errorString:"Unable to submit. Please try again.")
                                return
                            }
                         }
                    }
                }
                    
                else {
                    jsonBody = [
                    ParseClient.JSONResponseKeys.uniqueKey: "\(self.searchID!)",
                    ParseClient.JSONResponseKeys.firstName: "\(self.searchFirst!)",
                    ParseClient.JSONResponseKeys.lastName: "\(self.searchLast!)",
                    ParseClient.JSONResponseKeys.mapString: "\(self.searchLoc!)",
                    //ParseClient.JSONResponseKeys.mediaURL: "\(self.searchURL!)",
                    ParseClient.JSONResponseKeys.mediaURL: "\(self.NewLinkInput.text!)",
                    ParseClient.JSONResponseKeys.latitude: self.lat!,
                    ParseClient.JSONResponseKeys.longitude: self.long!]
                    
                    ParseClient.sharedInstance().postStudentLocations(jsonBody){ (success, errorString) in
                        if(success) {
                            // "Successfully submitted location")
                            dispatch_async(dispatch_get_main_queue()) {
                                let alert = UIAlertController(title: "Student Location", message: "Location Submitted Sucessfully!", preferredStyle: .Alert)
                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                                    (_)in
                                    self.performSegueWithIdentifier("unwindToMap", sender: self)
                                })
                                
                                alert.addAction(OKAction)
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.popAlert("ERROR", errorString:"Unable to submit. Please try again.")
                                return
                            }
                        }
                    }
                }
            }
        
    }
    

}

