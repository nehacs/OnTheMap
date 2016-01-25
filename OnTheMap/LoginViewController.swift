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
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: Login
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        self.debugTextLabel.text = ""
        UdacityClient.sharedInstance().login(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Udacity login failed", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                        // Do nothing
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
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
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    @IBAction func signupAction(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        let signupUrlString = "https://www.udacity.com/account/auth#!/signin"
        app.openURL(NSURL(string: signupUrlString)!)
    }
}
