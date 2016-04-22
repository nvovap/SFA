//
//  NVPannotation.swift
//  Vega3
//
//  Created by Владимир Невинный on 06.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit
import MapKit

class NVPAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        
        super.init()
    }
   
}
