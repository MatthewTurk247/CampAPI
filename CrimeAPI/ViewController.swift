//
//  ViewController.swift
//  CrimeAPI
//
//  Created by Matthew Turk on 8/15/15.
//  Copyright (c) 2015 Turk. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var CrimeMapView: MKMapView!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont(name: "Avenir Next Condensed", size: 20)!]
        self.CrimeMapView.showsUserLocation = true
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled");
        }
        
        let baseURLString:String = "https://api.forecast.io/forecast/c0673733d5c8627fd8b349f3d438408d/37.8267,-122.423"
        var request = NSURLRequest(URL: NSURL(string: baseURLString)!)
        var data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        let jsonResult: AnyObject! = (try? NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)) as? NSDictionary
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            //            if (!data) {
            //                println("\(__FUNCTION__): sendAsynchronousRequest error: \(connectionError)")
            //                return
            //            } else if (response.isKindOfClass(NSHTTPURLResponse.classForCoder())) {
            //                println("\(__FUNCTION__): sendAsynchronousRequest status code != 200: response = \(response)")
            //                return
            //            }
        })
        
        var parserError:NSErrorPointer = nil;
        //var dictionary:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: 0, error: &parserError)
        var dict:AnyObject?
        do {
            dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
        } catch var error as NSError {
            parserError.memory = error
            dict = nil
        }
        //        if (!dictionary) {
        //            println("\(__FUNCTION__): JSONObjectWithData error: \(parserError); data = \(NSString(data: data, encoding: NSUTF8StringEncoding)))")
        //            return
        //        }
        var itemsString = "latitude"
        var items:AnyObject = (dict?.objectForKey(itemsString))!
        print(dict)
        
//        let APIKey = "3aaa6f2e9a065b63266a8a9917ac5073"
//        let baseURLString:String = "https://api.forecast.io/forecast/\(APIKey)/37.8267,-122.423"
//        var request = NSURLRequest(URL: NSURL(string: baseURLString)!)
//        var data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
//        //let jsonResult: AnyObject! = (try? NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)) as? NSDictionary
//        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
//            //            if (!data) {
//            //                println("\(__FUNCTION__): sendAsynchronousRequest error: \(connectionError)")
//            //                return
//            //            } else if (response.isKindOfClass(NSHTTPURLResponse.classForCoder())) {
//            //                println("\(__FUNCTION__): sendAsynchronousRequest status code != 200: response = \(response)")
//            //                return
//            //            }
//        })
//        
//        var parserError:NSErrorPointer = nil;
//        //var dictionary:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: 0, error: &parserError)
//        var dict:AnyObject?
//        do {
//            dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
//        } catch var error as NSError {
//            //parserError.memory = error
//            dict = nil
//        }
//        //        if (!dictionary) {
//        //            println("\(__FUNCTION__): JSONObjectWithData error: \(parserError); data = \(NSString(data: data, encoding: NSUTF8StringEncoding)))")
//        //            return
//        //        }
//        //var itemsString = "items"
//        //var items:NSMutableArray = dict?.objectForKey(itemsString) as! NSMutableArray
//        print(dict)
//        print(data)
//        //print(jsonResult)
//        print(baseURLString)
        //navigationController?.toolbar.barTintColor = UIColor.grayColor()
        let lat:CLLocationDegrees = 37.3321115
        let long:CLLocationDegrees = -122.0307624
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        
        self.CrimeMapView.setRegion(theRegion, animated: true)
        
        let theLocationPin = MKPointAnnotation()
        
        let pinTitle = "The Location Pin"
        
        let pinSubtitle = "The Location Subtitle"
        
        theLocationPin.coordinate = location
        
        theLocationPin.title = "\(pinTitle)"
        theLocationPin.subtitle = "\(pinSubtitle)"
        
        //self.CrimeMapView.addAnnotation(theLocationPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
        })
    }

    func displayLocationInfo(placemark: CLPlacemark) {
        self.locationManager.stopUpdatingLocation()
        print(placemark.locality)
        print(placemark.postalCode)
        print(placemark.administrativeArea)
        print(placemark.country)
        print(placemark.location)
        placemark.location!.coordinate.longitude
        placemark.location!.coordinate.latitude
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: placemark.location!.coordinate.latitude, longitude: placemark.location!.coordinate.longitude)
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        self.CrimeMapView.setRegion(MKCoordinateRegion(center: location, span: theSpan), animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
}
