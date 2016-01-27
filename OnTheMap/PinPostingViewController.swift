//
//  PinPostingController.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/18/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit
import MapKit

class PinPostingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    
    @IBOutlet weak var enterUrlTextField: UITextField!
    @IBOutlet weak var locationTextView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var errorTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.locationTextField.delegate = self
        self.enterUrlTextField.delegate = self
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        let tabViews = storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
        presentViewController(tabViews, animated: false, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.errorTextField.hidden = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.locationTextField.resignFirstResponder()
        self.enterUrlTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func findOnMapAction(sender: AnyObject) {
        if (locationTextField.text!.isEmpty) {
            self.errorTextField.text = "Please enter a location."
        } else {
            activityIndicatorView.startAnimating()
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationTextField.text!, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    self.errorTextField.hidden = false
                    if (error?.code == 8) {
                        dispatch_async(dispatch_get_main_queue()) {
                            let alert = UIAlertController(title: "Failed to find location", message: "Invalid location.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                                // Do nothing
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            let alert = UIAlertController(title: "Failed to find location", message: "Unknown error in location.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                                // Do nothing
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
                if let placemark = placemarks?.first {
                    self.text1.hidden = true
                    self.text2.hidden = true
                    self.text3.hidden = true
                    self.locationTextView.hidden = true
                    self.locationTextField.hidden = true
                    self.errorTextField.hidden = true
                    self.findOnMapButton.hidden = true
                    
                    self.enterUrlTextField.hidden = false
                    self.mapView.hidden = false
                    self.submitButton.hidden = false
                    
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                    self.mapView.addAnnotation(annotation)
                    self.mapView.centerCoordinate = annotation.coordinate;
                }
                self.activityIndicatorView.stopAnimating()
            })
        }
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        if (self.enterUrlTextField.text!.isEmpty) {
            self.errorTextField.hidden = false
            self.errorTextField.text = "Please enter a URL"
        } else {
            self.errorTextField.hidden = true
            UdacityClient.sharedInstance().getUserData() { (success, errorString) in
                if success {
                    self.postStudentLocation()
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        let alert = UIAlertController(title: "Failed to post student location", message: "Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                            // Do nothing
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func postStudentLocation() {
        dispatch_async(dispatch_get_main_queue(), {
            ParseClient.sharedInstance().postStudentLocation(UserData.userId, firstName: UserData.firstName, lastName: UserData.lastName, mediaURL: self.enterUrlTextField.text!, mapString: self.locationTextField.text!) { (success, errorString) in
                if success {
                    self.goBackToTabs()
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        let alert = UIAlertController(title: "Failed to post student location", message: "Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                            // Do nothing
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
    func goBackToTabs() {
        dispatch_async(dispatch_get_main_queue(), {
            let tabViews = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(tabViews, animated: false, completion: nil)
        })
    }
}