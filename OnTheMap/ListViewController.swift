//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/31/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    //Initializes the Students Variable that will be used to populate the List
    var studentsloc: [ParseStudents] = [ParseStudents]()
    var userdata: [UdacityUser] = [UdacityUser]()

    
    // Populates the List
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let stud = self.studentsloc[indexPath.row]
        let Fullname = stud.firstname+" "+stud.lastname
        cell.textLabel?.text = Fullname+"  ("+stud.Loc!+")"
        cell.imageView!.image = UIImage(named: "Info")
        return cell
    }

    
    // Counts the number of Entries on the List
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentsloc.count
    }
    
    
    // Links the URL that is associated with each entry on the List
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let location = self.studentsloc[indexPath.row]
        let mediaURL = location.Link!
        
        if (validUrlChk (mediaURL) == false) {
            self.errorAlert("Invalid Link")
        }
        else {
            app.openURL(NSURL(string: mediaURL)!)
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
    
    
    // MARK: Outlets
    @IBOutlet weak var ListTableView: UITableView!
    @IBOutlet weak var Logout: UIBarButtonItem!
    @IBOutlet weak var Refresh: UIBarButtonItem!
    @IBOutlet weak var EditUser: UIBarButtonItem!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getStudentLocations()
    }

    
    // Refresh Button
    @IBAction func refresh() {
        getStudentLocations()
    }
    
    
    // LogOut Button
    @IBAction func LogOutPressed (sender: AnyObject) {
        UdacityClient.sharedInstance().UdacityLogOut() {(success, errorString) in
            if (success == true) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    }
                )
            } else {
                print("Unable to LogOut!")
                self.errorAlert("Unable to LogOut! TryAgain")
            }
        }
    }

    
/////////////////////////
    @IBAction func EditPin(sender: AnyObject) {
        UdacityClient.sharedInstance().UdacityUserData() {(success, results, errorString) in
            if(results != nil) {
                self.userdata = results!
                    print("Found all student values for \(self.userdata.uFirstname)")
                
            } else {
                print("Could not find all student values")
                self.errorAlert("Unable to get student data. Please try again.")
              }
        }
    }
    
    
    // Loads the Student Info
    func getStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations() { (sucess, results, errorString) in
            if(results != nil) {
                self.studentsloc = results!
                dispatch_async(dispatch_get_main_queue()) {
                    self.ListTableView.reloadData()
                }
            } else {
                print("Didn't get student locations")
                self.errorAlert("Could not download student locations")
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


    

