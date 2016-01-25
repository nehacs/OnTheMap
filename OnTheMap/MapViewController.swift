//
//  FirstViewController.swift
//  OnTheMap
//
//  Created by Neha Agarwal on 1/10/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseClient.sharedInstance().getLocations() { (success, locations, errorString) in
            if success {
                UserData.students = StudentInformation.studentsFromResults(locations)
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadMapAnnotations()
                })
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
    
    func loadMapAnnotations() {
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for student in UserData.students {
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.link
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        self.mapView.delegate = self
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view".
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = MKPinAnnotationView.redPinColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    // MARK: - Actions
    
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
        self.viewDidLoad()
    }
    
}