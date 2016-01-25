//
//  SecondViewController.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/10/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getLocations() { (success, locations, errorString) in
            if success {
                UserData.students = StudentInformation.studentsFromResults(locations)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Udacity download failed", message: "Unable to get student locations. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                        // Do nothing
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: UITableViewController
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationTableViewCell"
        let location = UserData.students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = "\(location.firstName) \(location.lastName)"
        cell.imageView!.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.students.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = UserData.students[indexPath.row]
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: student.link)!)
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        UdacityClient.sharedInstance().logout() { (success, errorString) in
            if success {
                self.completeLogout()
            } else {
                print("Failed to logout")
            }
        }
    }
    
    func completeLogout() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

    @IBAction func pinAction(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PinPostingViewController")
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        self.tableView?.reloadData()
    }
}

