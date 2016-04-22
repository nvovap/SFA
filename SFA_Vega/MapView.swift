//
//  MapView.swift
//  Vega3
//
//  Created by Владимир Невинный on 06.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate  {

    @IBOutlet weak var map: MKMapView!
    
    
    private var currentAnnotetion: MKAnnotation?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for annotation in self.map.annotations {
            self.map.removeAnnotation(annotation)
        }
        
        
        
       // if let inventores = NVPInventory.getAllInventory() {
        
        if let orders = NVPOrder.getOrdersToday() {
            
            var zoomRect: MKMapRect = MKMapRectNull
            
            for order in orders {
                let coordinate = CLLocationCoordinate2D(latitude: order.latitude.doubleValue, longitude: order.longitude.doubleValue)
                
                let annotation = NVPAnnotation(coordinate: coordinate, title: order.store.name, subtitle: order.date.smallDateAddTime)
                
                
                let center = MKMapPointForCoordinate(coordinate)
                
                let rect = MKMapRectMake(center.x - 2000, center.y-2000, 4000, 4000)
                
                zoomRect = MKMapRectUnion(zoomRect, rect)
                
                self.map.addAnnotation(annotation)
            }
            
            zoomRect = self.map.mapRectThatFits(zoomRect)
            
            self.map.setVisibleMapRect(zoomRect, animated: true)
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /*if let distances = NVPDistances.getDistances() {
            
            var zoomRect: MKMapRect = MKMapRectNull
            
            for distance in distances {
                let coordinate = CLLocationCoordinate2D(latitude: distance.latitude.doubleValue, longitude: distance.longitude.doubleValue)
                
                var subtitle = ""
                
                if let last = distance.lastDistance {
                    subtitle = last.date.smallDateAddTime
                }
                
                let annotation = NVPAnnotation(coordinate: coordinate, title: distance.date.smallDateAddTime, subtitle: subtitle)
                
                
                let center = MKMapPointForCoordinate(coordinate)
                
                let rect = MKMapRectMake(center.x - 20000, center.y-20000, 40000, 40000)
                
                zoomRect = MKMapRectUnion(zoomRect, rect)
                
                self.map.addAnnotation(annotation)
            }
        }*/
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        
        
        currentAnnotetion = view.annotation
        
      
        
        
       /* let request = MKDirectionsRequest()
        
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: view.annotation.coordinate, addressDictionary: nil))
        
        request.setDestination(destination)
        
        request.transportType = MKDirectionsTransportType.Walking
       // request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        
        direction.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if error == nil {
                println(response.routes.last?.distance)
                
                self.map.removeOverlays(self.map.overlays)
                
                var routes: [MKRoute] = []
                
                for route in response.routes {
                    if let route = route as? MKRoute {
                        self.map.addOverlay(route.polyline)
                    }
                }
                
               // self.map.addOverlays(routes)
            }
        }*/
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        
        
        pin.pinTintColor = UIColor.greenColor()
       
        pin.canShowCallout = true
        
        /*  pin.animatesDrop
        
        pin.draggable*/
        
        let descriptionButton = UIButton(type: .DetailDisclosure) 
        
        descriptionButton.addTarget(self, action: "openDetail:", forControlEvents: .TouchUpInside)
        
        
        pin.rightCalloutAccessoryView = descriptionButton
        
        
        
        
        return pin
        
    }
    
    
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        var renderer: MKPolylineRenderer
        
        
        let overlay =  overlay as! MKPolyline
        renderer = MKPolylineRenderer(polyline: overlay)
            
        renderer.lineWidth = 5
        renderer.strokeColor  = UIColor.redColor()
            
        
        return renderer
    }
    
    
    
    
    func openDetail(sender: UIButton) {
        if let annotation = self.currentAnnotetion {
            
            if let text = annotation.title {
                let alert = UIAlertController(title: "Адрес", message: text, preferredStyle: UIAlertControllerStyle.Alert)
                
                
                //(title: "Адрес", message: text, delegate: nil, cancelButtonTitle: "Ok")
                
                
                alert.showViewController(self, sender: nil)
            }
            
            
            
           /* let geoCoder = CLGeocoder()
            
            
            let loc = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
           
            
            
            geoCoder.reverseGeocodeLocation(loc , completionHandler: { (returns, error) -> Void in
                if error == nil {
                    
                    for ret in returns  {
                        if let ret = ret as? CLPlacemark {
                            println(ret.name)
                            println(ret.thoroughfare)
                            println(ret.subThoroughfare)
                            println(ret.locality)
                            println(ret.subLocality)
                            println(ret.administrativeArea)
                            println(ret.subAdministrativeArea)
                            println(ret.postalCode)
                            println(ret.inlandWater)
                            println(ret.country)
                            println(ret.inlandWater)
                            println(ret.ocean)
                            println(ret.areasOfInterest)
                            
                            println("================================")
                            
                            println(ret.addressDictionary)
                        }
                        
                    }
                }
            })*/
            
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
