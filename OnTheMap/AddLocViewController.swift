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
    
    var searchLoc:String?
    var searchName: String?
    var searchID: String?
    var searchCurrLoc: String?
    var searchURL: String?
    var searchFirst: String?
    var searchLast: String?
    
    var lat:Double?
    var long:Double?
    
    
    // Display an Alrt Box if there is an ERROR
    func errorAlert(errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        SearchForLocation()
    }

    
    
    func SearchForLocation() {
        
        SearchLocName.text = searchLoc
        OldLocation.text = searchCurrLoc
        OldLink.text = searchURL
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchLoc
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            
            
            if localSearchResponse == nil{
                self.errorAlert("Place Not Found")
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
    
        @IBAction func submitLocation() {
            let jsonBody:[String:AnyObject] = [
            ParseClient.JSONResponseKeys.uniqueKey: "\(self.searchID!)",
            ParseClient.JSONResponseKeys.firstName: "\(self.searchFirst!)",
            ParseClient.JSONResponseKeys.lastName: "\(self.searchLast!)",
            ParseClient.JSONResponseKeys.mapString: "\(self.searchLoc!)",
            ParseClient.JSONResponseKeys.mediaURL: "\(self.searchURL!)",
            ParseClient.JSONResponseKeys.latitude: self.lat!,
            ParseClient.JSONResponseKeys.longitude: self.long!]
            print("test")
            ParseClient.sharedInstance().postStudentLocations(jsonBody){ (success, errorString) in
                if(success) {
                    
                    print("Successfully submitted location")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorAlert("Successfully submitted location!")
                        self.performSegueWithIdentifier("MapViewController", sender: self)
                    }
                } else {
                    print("Location submission errored out")
                    self.errorAlert("Unable to submit. Please try again.")
                  }

            }
    }
        
   }