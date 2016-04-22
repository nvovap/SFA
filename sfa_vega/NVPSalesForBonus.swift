//
//  NVPSalesForBonus.swift
//  sfa_vega
//
//  Created by nvovap on 2/25/16.
//  Copyright © 2016 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit


/*
@NSManaged var confirmation: NSNumber
@NSManaged var id: String
@NSManaged var date: NSDate
@NSManaged var numberDocIn1C: String
@NSManaged var received: NSNumber
@NSManaged var store: NVPStore
@NSManaged var section: NSSet?
*/

@objc(NVPSalesForBonus)
class NVPSalesForBonus: NSManagedObject {

    class func insertSales(store _store: NVPStore) -> (NVPSalesForBonus?)  {
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("SalesForBonus", inManagedObjectContext: managedObjectContext) {
                let sales: NVPSalesForBonus = NVPSalesForBonus(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                sales.date = NSDate()
                sales.id   = NSUUID().UUIDString
                sales.store = _store
                
                sales.numberDocIn1C = ""
                
                sales.confirmation = false
                
                sales.sent = false
        
                
                return sales
            }
        }
        
        return nil
    }
    
    class func  getAllSalesForBonus() -> ([NVPSalesForBonus]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "SalesForBonus")
        
        
        do {
            
            if let results: [NVPSalesForBonus] = try managedObjectContext.executeFetchRequest(request) as? [NVPSalesForBonus] {
                
                return results
                
                
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
        
        return nil
    }
    
    class func  getSalesForBonusToday() -> ([NVPSalesForBonus]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "SalesForBonus")
        
        let predicate = NSPredicate(format: "date >= %@", NSDate().startDay)
        
        request.predicate = predicate
        
        do {
            
            if let results: [NVPSalesForBonus] = try managedObjectContext.executeFetchRequest(request) as? [NVPSalesForBonus] {
                return results
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
        
        return nil
    }
    
    
    class func  getSalesForBonusForSent() -> ([NVPSalesForBonus]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "SalesForBonus")
        
        let predicate = NSPredicate(format: "confirmation == false")
        
        request.predicate = predicate
        
        
        
        do {
            
            if let results: [NVPSalesForBonus] = try managedObjectContext.executeFetchRequest(request) as? [NVPSalesForBonus] {
                return results
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
        
        return nil
    }
    
    class func  confirm(id: String, numberDocIn1C: String) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "SalesForBonus")
        
        
        let predicate = NSPredicate(format: "id like '*"+id+"*'")
        
        request.predicate = predicate
        
        request.fetchLimit = 1
        
        
        
        do {
            
            if let results: [NVPSalesForBonus] = try managedObjectContext.executeFetchRequest(request) as? [NVPSalesForBonus] {
                if let sales = results.first  {
                    sales.confirmation = true
                    sales.numberDocIn1C = numberDocIn1C
                }
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
    }

}


extension NVPSalesForBonus {
    
    @NSManaged var confirmation: NSNumber
    @NSManaged var id: String
    @NSManaged var date: NSDate
    @NSManaged var numberDocIn1C: String
    @NSManaged var sent: NSNumber
    @NSManaged var store: NVPStore
    @NSManaged var section: NSSet?
    
}
