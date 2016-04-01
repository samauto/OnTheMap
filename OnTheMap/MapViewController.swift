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

        // MARK: Outlets       
        @IBOutlet weak var mapView: MKMapView!
        @IBOutlet weak var Logout: UIBarButtonItem!
        @IBOutlet weak var Refresh: UIBarButtonItem!

        
        override func viewDidLoad() {
            super.viewDidLoad()
            loadStudents()
        }
    
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(true)
            loadStudents()
        }
        
    
        // Refresh Button
        @IBAction func RefreshPressed () {
            for annotation : MKAnnotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
            loadStudents()
        }

        
        // LogOut Button
        @IBAction func LogOutPressed (sender: AnyObject) {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
            
        
        // Loads the Students and add them to the pin array that will populate the map
        func loadStudents() {
            ParseClient.sharedInstance().getStudentLocations(){(success, result, error) in
                if (success == true) {
                    dispatch_async(dispatch_get_main_queue()) {

                        var annotations = [MKPointAnnotation]()
                        
                        for dictionary in result! {
                            
                            let lat = CLLocationDegrees(dictionary.lat! as Double)
                            let long = CLLocationDegrees(dictionary.long! as Double)
                            
                            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            
                            let first = dictionary.firstname as String
                            let last = dictionary.lastname as String
                            let mediaURL = dictionary.Link! as String
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coordinate
                            annotation.title = "\(first) \(last)"
                            annotation.subtitle = mediaURL
                            
                            annotations.append(annotation)
                            
                        }
                        
                        self.mapView.delegate = self
                        self.mapView.addAnnotations(annotations)
                    }
                }
                else {
                    self.errorAlert("Could Not Download Student Locarions")
                }
                
            }
        }

        
        // Formats the Pins
        func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
                pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
        
        // Opens the Links that are associated with each pin
        func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                let app = UIApplication.sharedApplication()
                if let toOpen = view.annotation?.subtitle! {
                    print (toOpen)
                    if (validUrlChk (toOpen) == false) {
                        self.errorAlert("Invalid Link")
                    }
                    else {
                        app.openURL(NSURL(string: toOpen)!)
                    }
                }
            }
        }
        

        // Checks if the URL is valid or not
        func validUrlChk (URLinput: String?) -> Bool {
            if URLinput != nil {
                if let URLinput = NSURL(string: URLinput!) {
                    // check if your application can open the NSURL instance
                    return UIApplication.sharedApplication().canOpenURL(URLinput)
                }
            }
            return false
        }

        
        // Display an Alrt Box if there is an ERROR
        func errorAlert(errorString: String) {
            let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }