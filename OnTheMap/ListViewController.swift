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
    
    //Initializes the User Variable that will be used to populate the Map
    var user: [UdacityUser] = [UdacityUser]()
    var userFirst: String!
    var userLast: String!
    var userFN: String?
    var userLoc: String?
    var userLink: String?
    var userID: String?
    var userEdit: String! = "false"
    var userLat: Double?
    var userLong: Double?

    
    // FUNC:  Loads the Student Info
    func getStudentLocations() {
        UdacityClient.sharedInstance().getUserLocations() {(success, results, errorString) in
            if(results != nil) {
                self.user = results!
                for dictionary in results! {
                    self.userFN = dictionary.uFirstname+" "+dictionary.uLastname
                    
                    
                }
            }
        }
        
        ParseClient.sharedInstance().getStudentLocations() { (sucess, results, errorString) in
            if(results != nil) {
                self.studentsloc = results!
                dispatch_async(dispatch_get_main_queue()) {
                    self.ListTableView.reloadData()
                }
            } else {
                self.popAlert("ERROR", errorString: "Could not download student locations")
            }
        }
    }

    
    
    // FUNC:  Populates the List
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CustomListViewCell = tableView.dequeueReusableCellWithIdentifier("CustomListViewCell") as! CustomListViewCell
        
        let stud = self.studentsloc[indexPath.row]
       
        
        cell.InfoButton.image = UIImage(named: "Info")
        
        let FN = stud.firstname+" "+stud.lastname
        cell.Stud_Name.text = FN
        cell.Stud_Loc.text = "("+stud.Loc+")"
        
        if (FN == self.userFN) {
            cell.Stud_Name.textColor = UIColor.redColor()
            cell.Stud_Loc.textColor = UIColor.redColor()
            cell.EditButton.hidden = false
            cell.DeleteButton.hidden = true
            self.userFirst = stud.firstname
            self.userLast = stud.lastname
            self.userLoc = stud.Loc
            self.userLink = stud.Link
            self.userID = stud.id
            self.userLat = stud.lat
            self.userLong = stud.long
        }
        else {
            cell.Stud_Name.textColor = UIColor.blackColor()
            cell.Stud_Loc.textColor = UIColor.blackColor()
            cell.EditButton.hidden = true
            cell.DeleteButton.hidden = true
        }
        
        return cell
    }
    
    
    // FUNC:  Counts the number of Entries on the List
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentsloc.count
    }
    
    
    // FUNC:  Links the URL that is associated with each entry on the List
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let location = self.studentsloc[indexPath.row]
        let mediaURL = location.Link
        
        
        if (validUrlChk (mediaURL) == false) {
            self.popAlert("ERROR",errorString: "Invalid Link: '\(mediaURL)'")
        }
        else {
            app.openURL(NSURL(string: mediaURL)!)
        }
    }
    
    
    // FUNC:  Deletes the Student Location
    @IBAction func DeleteStudentLocation () {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to Delete", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: nil))
        
        let YESAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {
            (_)in
            self.performSegueWithIdentifier("unwindToMap", sender: self)
        })
        
        alert.addAction(YESAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // FUNC:  Checks if the URL is valid or not
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
        getStudentLocations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getStudentLocations()
    }

    
    // FUNC:  Refresh Button
    @IBAction func refresh() {
        getStudentLocations()
    }
    
    
    // FUNC:  LogOut Button
    @IBAction func LogOutPressed (sender: AnyObject) {
        UdacityClient.sharedInstance().UdacityLogOut() {(success, errorString) in
            if (success == true) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    }
                )
            } else {
                self.popAlert("ERROR",errorString: "Unable to LogOut! TryAgain")
            }
        }
    }

    // FUNC: prepare for Seque
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

    // FUNC:  Deletes the Student Location
    @IBAction func EditStudentLocation () {
        self.userEdit = "EDIT"
    }
    
  
    
    // FUNC:  Display an Alrt Box if there is an ERROR
      func popAlert(typeOfAlert: String, errorString: String) {
        let alertController = UIAlertController(title: typeOfAlert, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}




