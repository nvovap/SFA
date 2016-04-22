//
//  NVPInventory.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 26.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit


@objc(NVPInventory)
class NVPInventory: NSManagedObject {

    
    @NSManaged var date: NSDate
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var horizontalAccuracy: NSNumber
    @NSManaged var distance: NSNumber
    @NSManaged var id: String
    @NSManaged var section: NSSet?
    @NSManaged var story: NVPStore
    @NSManaged var confirmation: NSNumber
    @NSManaged var sent: NSNumber
    @NSManaged var numberDocIn1C: String
    @NSManaged var visitsPhoto: NSSet?
    
    
    
    
    
    
    class func insertInventory(story _story: NVPStore) -> (NVPInventory?)  {
    
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("Inventory", inManagedObjectContext: managedObjectContext) {
                let inventory: NVPInventory = NVPInventory(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                
                inventory.date    = NSDate()
                inventory.latitude  = 0
                inventory.longitude = 0
                inventory.distance = 0
                inventory.id      = NSUUID().UUIDString
                inventory.story   = _story
                
                inventory.confirmation = false
                inventory.sent = false
                inventory.numberDocIn1C   = ""
                
                //inventory.latitude =
                
                
                
                return inventory
            }
        }
        
        return nil
    }
    
    
    class func  getLastInventory(idStory _id: String, idInventory: String?) -> (NVPInventory?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Inventory")
        
        var predicateString = ""
        
        if let idInventory = idInventory {
            predicateString = " && id != '"+idInventory+"'"
        }
        
        let predicate = NSPredicate(format: "story.id == \""+_id+"\""+predicateString)
        
        request.predicate = predicate
        
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        request.sortDescriptors = [sort]
        
        request.fetchLimit = 1
        
        
        request.relationshipKeyPathsForPrefetching = ["section"]
        
        do {
            
            if let results: [NVPInventory] = try managedObjectContext.executeFetchRequest(request) as? [NVPInventory] {
                if let inventory = results.first  {
                    return inventory
                }
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
        
        return nil
    }
    
    class func  getAllInventory() -> ([NVPInventory]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Inventory")
        
        do {
            
            if let results: [NVPInventory] = try managedObjectContext.executeFetchRequest(request) as? [NVPInventory] {
               return results
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
        
        return nil
    }
    
    class func  getAllLastInventory() -> ([NVPInventory]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Inventory")
        
        request.resultType = .DictionaryResultType
        
        request.propertiesToFetch = ["story"]
        request.propertiesToGroupBy = ["story"]
        
        
        do {
            let res = try managedObjectContext.executeFetchRequest(request) as [AnyObject]?
            
            //var rrr: [NVPStore] = [NVPStore]()
            
            if let res = res {
                for rs in res {
                    print(rs.story!.name)
                    
                }
            }
        }
        catch {
            fatalError("Fetching from the store failed")
        }
        
        
       
        
        do {
            if let results: [NSManagedObject] = try managedObjectContext.executeFetchRequest(request) as? [NSManagedObject] {
            
            for rs in results {
               print(rs)
            }
            
           //return results
            }
        } catch {
            fatalError("Fetching from the store failed")
        }

        
        return nil
    }
    
    class func  getInventoresForSent() -> ([NVPInventory]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Inventory")
        
        let predicate = NSPredicate(format: "confirmation == false")
        
        request.predicate = predicate
        
        
        do {
            if let results: [NVPInventory] = try managedObjectContext.executeFetchRequest(request) as? [NVPInventory] {
                return results
            }
        } catch {
                fatalError("Fetching from the store failed")
        }
        
        return nil
    }
    
    
   
    
    class func  confirm(id: String, numberDocIn1C: String) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Inventory")
        
    
        let predicate = NSPredicate(format: "id == '"+id+"'")
        
        request.predicate = predicate
        
        request.fetchLimit = 1
        
        do {
            if let results: [NVPInventory] = try managedObjectContext.executeFetchRequest(request) as? [NVPInventory] {
                if let inventory = results.first  {
                    inventory.confirmation = true
                    inventory.numberDocIn1C = numberDocIn1C
                    print("\(inventory.confirmation)  \(inventory.numberDocIn1C)")
                }
            
            }
        } catch {
            fatalError("Fetching from the store failed")
        }

    }
       

}
