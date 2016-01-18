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
    
    var locations: [Location] = [Location]()
    
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
                self.locations = Location.locationsFromResults(locations)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    // MARK: UITableViewController
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationTableViewCell"
        let location = locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = location.firstName + " " + location.lastName
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /* Push the movie detail view */
//        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
//        controller.movie = movies[indexPath.row]
//        self.navigationController!.pushViewController(controller, animated: true)
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
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
    }
}

