//
//  NVPVisitPhotos.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 28.08.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//
import Foundation
import CoreData
import UIKit

@objc(NVPVisitPhotos)
class NVPVisitPhotos: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var inventory: NVPInventory
    @NSManaged var photo: String
    @NSManaged var namePhoto: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var horizontalAccuracy: NSNumber
    @NSManaged var sent: NSNumber
    @NSManaged var received: NSNumber
   
    
    
    
    
    
    class func insertPhoto(date date: NSDate, inventory: NVPInventory,  photo: String, namePhoto: String) -> (NVPVisitPhotos!)  {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("VisitPhotos", inManagedObjectContext: managedObjectContext) {
                let photos: NVPVisitPhotos = NVPVisitPhotos(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                
                let loc = GetLocation.shared
                
                photos.date          = date
                photos.inventory     = inventory
                photos.photo         = photo
                photos.namePhoto     = namePhoto
                photos.latitude      = loc.latitude
                photos.longitude     = loc.longitude
                photos.horizontalAccuracy    = loc.horizontalAccuracy
    
                
                photos.sent = false
                photos.received = false
                
                return photos
            }
        }
        
        return nil
    }
    
    
    class func  getPhotos(inventory inventory: NVPInventory, sendToFTP: Bool) -> ([NVPVisitPhotos]?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "VisitPhotos")
        
        //let predicate = NSPredicate(format: "date >= %@ AND date <= %@ AND inventory == %@", date.startDay, date, inventory)
        
        var pridecateString = "inventory == %@"
        
        if sendToFTP {
            pridecateString = "inventory == %@ and sent == false"
        }
        
        let predicate = NSPredicate(format: pridecateString, inventory)
        
        request.predicate = predicate
        
        do {
            if let results: [NVPVisitPhotos] = try managedObjectContext.executeFetchRequest(request) as? [NVPVisitPhotos] {
                return results
                
            }
        } catch {
            fatalError("Fetching from the store failed")
        }
        
        
        return nil
    }
}
