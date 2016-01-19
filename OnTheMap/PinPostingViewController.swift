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
    
    override func viewDidLoad() {
        self.locationTextField.delegate = self
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        let tabViews = storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
        presentViewController(tabViews, animated: false, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.errorTextField.hidden = true
    }
    
    @IBAction func findOnMapAction(sender: AnyObject) {
        if (locationTextField.text!.isEmpty) {
            self.errorTextField.text = "Please enter a location."
        } else {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationTextField.text!, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    self.errorTextField.hidden = false
                    if (error?.code == 8) {
                        self.errorTextField.text = "Invalid location"
                    } else {
                        self.errorTextField.text = "Unknown error in location"
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
            })
        }
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        UdacityClient.sharedInstance().getUserData() { (success, errorString) in
            if success {
                ParseClient.sharedInstance().postStudentLocation(UserData.userId, firstName: UserData.firstName, lastName: UserData.lastName, mediaURL: self.enterUrlTextField.text!, mapString: self.locationTextField.text!) { (success, errorString) in
                    if success {
                        
                    } else {
                        print("Failed to post student location")
                    }
                }
            } else {
                print("Failed to get User Data")
            }
        }
    }
}