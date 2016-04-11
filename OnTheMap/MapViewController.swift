//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/27/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit
import MapKit
    
    class MapViewController: UIViewController, MKMapViewDelegate {

        
        //Initializes the Students Variable that will be used to populate the Map
        var students: [ParseStudents] = [ParseStudents]()
        
        
        //Initializes the User Variable that will be used to populate the Map
        var user: [UdacityUser] = [UdacityUser]()
        var userFN: String!
        
        
        var userFirst: String!
        var userLast: String!
        var userLoc: String?
        var userLink: String?
        var userID: String?
        var userEdit: String! = "false"
        var userLat: Double?
        var userLong: Double?

        
        //Outlets
        @IBOutlet weak var mapView: MKMapView!
        @IBOutlet weak var Logout: UIBarButtonItem!
        @IBOutlet weak var Refresh: UIBarButtonItem!

        
        //FUNC: viewDidLoad
        override func viewDidLoad() {
            super.viewDidLoad()
            RefreshPressed()
            loadStudents()
        }
    
        
        //FUNC: viewWillAppear
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(true)
            loadStudents()
        }
    
    
        //FUNC: Refresh Button
        @IBAction func RefreshPressed () {
            for annotation : MKAnnotation in mapView.annotations {
                //mapView.removeAnnotation(annotation)
                mapView.addAnnotation(annotation)}
            //loadStudents()
        }

        
        //FUNC: LogOut Button
        @IBAction func LogOutPressed (sender: AnyObject) {
            UdacityClient.sharedInstance().UdacityLogOut() {(success, errorString) in
                if (success == true) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    )
                } else {
                    print("Unable to LogOut!")
                    self.popAlert("ERROR", errorString: "Unable to LOGOUT! TryAgain!")
                  }
            }
        }
        
        
        //FUNC: loadStudents():  Loads the Students and add them to the pin array that will populate the map and loads the User Info
        func loadStudents() {
            ParseClient.sharedInstance().getStudentLocations(){(success, result, error) in
                if (success == true) {
                    dispatch_async(dispatch_get_main_queue()) {

                        var annotations = [MKPointAnnotation]()
                        
                        for dictionary in result! {
                            
                            self.userLat = CLLocationDegrees(dictionary.lat as Double)
                            self.userLong = CLLocationDegrees(dictionary.long as Double)
                            
                            let coordinate = CLLocationCoordinate2D(latitude: self.userLat!, longitude: self.userLong!)
                            
                            self.userFirst = dictionary.firstname as String
                            self.userLast = dictionary.lastname as String
                            self.userLink = dictionary.Link as String
                            self.userLoc = dictionary.Loc as String
                            self.userID = dictionary.id as String
                            
                            let annotation = MKPointAnnotation()
                            
                            annotation.coordinate = coordinate
                            annotation.title = "\(self.userFirst) \(self.userLast )"
                            annotation.subtitle = self.userLink
                            annotations.append(annotation)
                            
                        }
                        
                        self.mapView.delegate = self
                        self.mapView.addAnnotations(annotations)
                    }
                }
                else {
                    self.popAlert("ERROR", errorString:"Could Not Download Student Locations")
                }
            }
            
            
            UdacityClient.sharedInstance().getUserLocations() {(success, results, errorString) in
                if(results != nil) {
                    self.user = results!
                    for dictionary in results! {
                        self.userFN = dictionary.uFirstname+" "+dictionary.uLastname
                    }
                }
            }

        }

        
        //FUNC: mapView(): Formats the Pins
        func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.leftCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                
                //Changes the Pin Properties of the User Pins
                if (annotation.title! == self.userFN){
                    print(annotation.title!!)
                    pinView!.pinTintColor = UIColor(red: 1.0, green:0.0, blue:0.0, alpha: 1.0)
                    pinView!.animatesDrop = true
                    
                    let editButton = UIButton(type: UIButtonType.System) as UIButton
                    editButton.frame.size.width = 35
                    editButton.frame.size.height = 35
                    editButton.backgroundColor = UIColor.whiteColor()
                    editButton.setImage(UIImage(named: "Edit"), forState: .Normal)
                    pinView!.rightCalloutAccessoryView = editButton
                    self.userEdit = "EDIT"
                    }
                //Changes the Pin Properties of the Other Students Pins
                else {
                    pinView!.pinTintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
                    pinView!.animatesDrop = false
                }
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
        
        //FUNC: prefare for Seque
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if let userupdateLocViewController: UpdateLocViewController = segue.destinationViewController as? UpdateLocViewController {
                userupdateLocViewController.searchName = self.userFN
                userupdateLocViewController.searchID = self.userID
                userupdateLocViewController.searchCurrLoc = self.userLoc
                userupdateLocViewController.searchURL = self.userLink
                userupdateLocViewController.searchFirst = self.userFirst
                userupdateLocViewController.searchLast = self.userLast
                userupdateLocViewController.searchEdit = self.userEdit
                userupdateLocViewController.searchLat = self.userLat
                userupdateLocViewController.searchLong = self.userLong
            }
        }

        
        //FUNC: mapView(): Opens the Links that are associated with each pin
        func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.leftCalloutAccessoryView {
                let app = UIApplication.sharedApplication()
                if let toOpen = view.annotation?.subtitle! {
                    //Determines if the Link is a valid URL
                    if (validUrlChk (toOpen) == false) {
                        self.popAlert("ERROR", errorString: "Invalid Link")
                    }
                    else {
                        app.openURL(NSURL(string: self.userLink!)!)
                    }
                }
            }
            else if control == view.rightCalloutAccessoryView {
                performSegueWithIdentifier("UpdateLocViewController", sender: self)
            }
        }
        
        

        

        //FUNC: validUrlChk(): Checks if the URL is valid or not
        func validUrlChk (URLinput: String?) -> Bool {
            if URLinput != nil {
                if let URLinput = NSURL(string: URLinput!) {
                    return UIApplication.sharedApplication().canOpenURL(URLinput)
                }
            }
            return false
        }

        
        //FUNC: popAlert(): Display an Alrt Box
        func popAlert(typeOfAlert: String, errorString: String) {
            let alertController = UIAlertController(title: typeOfAlert, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
        @IBAction func unwindToMap(segue: UIStoryboardSegue) {}
        
        }