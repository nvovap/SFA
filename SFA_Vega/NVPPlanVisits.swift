//
//  PlanVisits.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 28.08.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPPlanVisits)
class NVPPlanVisits: NSManagedObject {

    @NSManaged var dateStart: NSDate
    @NSManaged var dateEnd: NSDate
    @NSManaged var idStore: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    
    
    class func insertPlanVisits(dateStart dateStart: NSDate, dateEnd: NSDate, idStore: String, latitude: NSNumber, longitude: NSNumber) -> (NVPPlanVisits?)  {
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("PlanVisits", inManagedObjectContext: managedObjectContext) {
                let planVisits: NVPPlanVisits = NVPPlanVisits(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                
                planVisits.dateStart = dateStart
                planVisits.dateEnd   = dateEnd
                planVisits.idStore   = idStore
                planVisits.latitude  = latitude
                planVisits.longitude = longitude
                
                
                return planVisits
            }
        }
        
        return nil
    }
    
    
    class func  getAllPlanVisits() -> ([NVPPlanVisits]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "PlanVisits")
        
        
        do {
            
            if let results: [NVPPlanVisits] = try managedObjectContext.executeFetchRequest(request) as? [NVPPlanVisits] {
                
                return results
                
                
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
        
        
        
        
        return nil
    }

}
