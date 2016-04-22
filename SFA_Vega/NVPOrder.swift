//
//  NVPOrder.swift
//  Vega3
//
//  Created by Владимир Невинный on 07.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPOrder)
class NVPOrder: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var id: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var horizontalAccuracy: NSNumber
    @NSManaged var free: NSNumber
    @NSManaged var payForma2: NSNumber
    @NSManaged var section: NSSet?
    @NSManaged var store: NVPStore
    @NSManaged var confirmation: NSNumber
    @NSManaged var sent: NSNumber
    @NSManaged var shipped: NSNumber
  
    @NSManaged var comment: String
    @NSManaged var idInventory: String
    
    @NSManaged var numberDocIn1C: String
    
    class func insertOrder(store _store: NVPStore, free: Bool, payForma2: Bool) -> (NVPOrder?)  {
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("Order", inManagedObjectContext: managedObjectContext) {
                let order: NVPOrder = NVPOrder(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                order.date = NSDate()
                order.id   = NSUUID().UUIDString
                order.store = _store
                order.latitude  = 0
                order.longitude = 0
                order.horizontalAccuracy = 0
                order.free      = free
                order.payForma2 = payForma2
                
                order.comment = ""
                order.numberDocIn1C = ""
                
                order.confirmation = false
                order.sent = false
                
                order.shipped = false
                
                order.idInventory = "00000000-0000-0000-0000-000000000000"
                
                return order
            }
        }
        
        return nil
    }
    
    class func  getAllOrder() -> ([NVPOrder]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Order")
        
        
        do {
            
            if let results: [NVPOrder] = try managedObjectContext.executeFetchRequest(request) as? [NVPOrder] {
                
                return results
                
                
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
        
        
        
        
        return nil
    }
    
    class func  getOrdersToday() -> ([NVPOrder]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Order")
        
        let predicate = NSPredicate(format: "date >= %@", NSDate().startDay)
        
        request.predicate = predicate
        
        do {
            
            if let results: [NVPOrder] = try managedObjectContext.executeFetchRequest(request) as? [NVPOrder] {
                return results
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
        
        return nil
    }
    
    
    class func  getOrdersForSent() -> ([NVPOrder]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Order")
        
        let predicate = NSPredicate(format: "confirmation == false")
        
        request.predicate = predicate
        
     
        
        do {
            
            if let results: [NVPOrder] = try managedObjectContext.executeFetchRequest(request) as? [NVPOrder] {
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
        
        let request = NSFetchRequest(entityName: "Order")
        
        
        let predicate = NSPredicate(format: "id like '*"+id+"*'")
        
        request.predicate = predicate
        
        request.fetchLimit = 1
        
        
        
        do {
            
            if let results: [NVPOrder] = try managedObjectContext.executeFetchRequest(request) as? [NVPOrder] {
                if let order = results.first  {
                    order.confirmation = true
                    order.numberDocIn1C = numberDocIn1C
                    
                    print("\(order)")
                }
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
    }
    
    

}
