//
//  Extensions.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 14.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import MapKit

extension NSDate {
    
    
    var smallDate: String {
        let dateFormattter = NSDateFormatter()
        dateFormattter.dateFormat = "dd-MM-yyyy"
        
        return dateFormattter.stringFromDate(self)
    }
    
    var smallDateAddTime: String {
        let dateFormattter = NSDateFormatter()
        dateFormattter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        return dateFormattter.stringFromDate(self)
    }
    
    var startDay: NSDate {
        let dateFormattter = NSDateFormatter()
        dateFormattter.dateFormat = "dd-MM-yyyy 00:00:00"
        
        let stringDate = dateFormattter.stringFromDate(self)
        
        return dateFormattter.dateFromString(stringDate)!
    }
    
    var endDay: NSDate {
        let dateFormattter = NSDateFormatter()
        dateFormattter.dateFormat = "dd-MM-yyyy 23:59:59"
        
        let stringDate = dateFormattter.stringFromDate(self)
        
        return dateFormattter.dateFromString(stringDate)!
    }
    
    
}


extension String {
    var dateFromString : NSDate {
        let dateFormattter = NSDateFormatter()
        dateFormattter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        if let date = dateFormattter.dateFromString(self) {
            return date
        }
        
        
        return dateFormattter.dateFromString("01.01.0001 00:00:00")!
    }
}
