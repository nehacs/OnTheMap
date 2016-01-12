//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/10/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
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
        
//        self.addKeyboardDismissRecognizer()
//        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.removeKeyboardDismissRecognizer()
//        self.unsubscribeToKeyboardNotifications()
    }
    
    
    // MARK: Login
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        UdacityClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                self.debugTextLabel.text = errorString
            }
        })
    }
    
    // MARK: MapTabBarController
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
//            self.setUIEnabled(enabled: true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    // MARK: Udacity API
    
}
