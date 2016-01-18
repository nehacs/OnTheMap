//
//  PinPostingController.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/18/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit

class PinPostingViewController: UIViewController {
    
    @IBAction func cancelAction(sender: AnyObject) {
        let tabViews = storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
        presentViewController(tabViews, animated: false, completion: nil)
    }
    
    @IBAction func findOnMapAction(sender: AnyObject) {
    }
}