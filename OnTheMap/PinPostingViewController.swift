//
//  PinPostingController.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/18/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit
import MapKit

class PinPostingViewController: UIViewController {
    
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    
    @IBOutlet weak var enterUrlTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextView!
    @IBOutlet weak var findOnMapButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func cancelAction(sender: AnyObject) {
        let tabViews = storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
        presentViewController(tabViews, animated: false, completion: nil)
    }
    
    @IBAction func findOnMapAction(sender: AnyObject) {
        text1.hidden = true
        text2.hidden = true
        text3.hidden = true
        locationTextField.hidden = true
        findOnMapButton.hidden = true
        
        enterUrlTextField.hidden = false
        mapView.hidden = false
        submitButton.hidden = false
    }
    
    @IBAction func submitAction(sender: AnyObject) {
    }
}