//
//  GetLocation.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 02.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GetLocation:NSObject, CLLocationManagerDelegate {
    
    var maneger = CLLocationManager()
    
    var latitude: Double
    var longitude: Double
    var horizontalAccuracy: Double
    var update: Bool
    var alert: UIAlertController?
    
    class var shared: GetLocation {
        struct Static {
            static var token: dispatch_once_t = 0
            static var instance: GetLocation?
        }
        
        
        
        dispatch_once(&Static.token) {
            Static.instance = GetLocation()
        }
        
        return Static.instance!
    }
    
    
    override init(){
        
        
        
        self.latitude  = 0
        self.longitude = 0
        self.horizontalAccuracy = 0
        self.update = false
        
        super.init()
        
        
        self.maneger.desiredAccuracy = kCLLocationAccuracyBest
        
        self.maneger.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            self.maneger.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.maneger.requestAlwaysAuthorization()
        }
    }
    
    
/*    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            startUpdatingLocation()
        }
        
        switch status {
        case .AuthorizedAlways:
            maneger.startUpdatingLocation()
        case .NotDetermined:
            self.maneger.requestAlwaysAuthorization()
        case .Restricted, .Denied:
             alert = UIAlertController (title: "Не отключать!!!", message: "Надо включить определение местоположения!!!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let openAction = UIAlertAction(title: "ВКЛЮЧИТЬ", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            
            alert?.addAction(openAction)
        default: break
            
        }
    }*/
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        /*println(maneger.location.description)
        
        latitude  = self.maneger.location.coordinate.latitude
        longitude = self.maneger.location.coordinate.longitude*/
        
        if let lastLocation = locations.last {
            
            
            
            if self.horizontalAccuracy > lastLocation.horizontalAccuracy {
                self.latitude  = lastLocation.coordinate.latitude
                self.longitude = lastLocation.coordinate.longitude
                self.horizontalAccuracy = lastLocation.horizontalAccuracy
      
                update = true
            }
            
            if self.horizontalAccuracy <= 100 {
                manager.stopUpdatingLocation()
               // writeDistance()
            }
        }
        
       
        
        //maneger.stopUpdatingLocation()
        
    }
    
    func startUpdatingLocation() {
        update = false
        
        alert = nil
        
        self.horizontalAccuracy = 10000
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            maneger.startUpdatingLocation()
        case .NotDetermined:
            self.maneger.requestAlwaysAuthorization()
        case .Restricted, .Denied:
            alert = UIAlertController(title: "Не отключать!!!", message: "Надо включить определение местоположения!!!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let openAction = UIAlertAction(title: "ВКЛЮЧИТЬ", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            
            alert?.addAction(openAction)
            
        default: break
            
        }
    }
    
    func stopUpdatingLocation() {
        update = false
        
      //  writeDistance()
        
        maneger.stopUpdatingLocation()
    }
    
    
    
   
}
