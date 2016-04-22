//
//  NVPStore.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 28.08.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//
import Foundation
import CoreData
import UIKit

@objc(NVPStore)
class NVPStore: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var code: String
    @NSManaged var idClient: String
    
    @NSManaged var adress: String
    
    
    @NSManaged var idRTP: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    
    @NSManaged var oblast: String
    @NSManaged var region: String
    
    @NSManaged var category: NVPCategory?
    @NSManaged var client: NVPClient?
    @NSManaged var info: NVPInfoStory?
    @NSManaged var inventory: NSSet?
    @NSManaged var orders: NSSet?
    @NSManaged var salesForBonus: NSSet?
    
    
    
    //@NSManaged var visits: NSSet?
    
    class func insertStore(id _id: String, name: String, code: String,  idClient: String, category categoryName: String, adress: String,  idRTP: String, oblast:  String, region: String) -> (NVPStore!)  {
        
        if let store = self.getStore(id: _id) {
            store.id        = _id
            store.name      = name
            store.code      = code
            store.idClient  = idClient
            store.adress    = adress
            //  store.info      = NVPInfoStory.insertInfo(store: store, info: "")!
            
            
            if let client = NVPClient.getClient(id: idClient){
                store.client = client
            }
            
            let category  = NVPCategory.getCategory(categoryName)
            store.category  = category
            
            store.idRTP  = idRTP
            
            store.latitude = 0
            store.longitude = 0
            
            
            store.oblast = oblast
            store.region = region
            
            //print(region)
            
            
            return store
        }
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("Store", inManagedObjectContext: managedObjectContext) {
                let store: NVPStore = NVPStore(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                store.id        = _id
                store.name      = name
                store.code      = code
                store.idClient  = idClient
                store.adress    = adress
                //  store.info      = NVPInfoStory.insertInfo(store: store, info: "")!
                
                
                if let client = NVPClient.getClient(id: idClient){
                    store.client = client
                }
                
                let category  = NVPCategory.getCategory(categoryName)
                store.category  = category
                
                store.idRTP  = idRTP
                
                store.latitude = 0
                store.longitude = 0
                
                store.oblast = oblast
                store.region = region
                
                
                
                return store
            }
        }
        
        return nil
        
        
    }
    
    
    class func  getStore(id _id: String) -> (NVPStore?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Store")
        
        let predicate = NSPredicate(format: "id == \""+_id+"\"")
        
        request.predicate = predicate
        
        do {
            if let results: [NVPStore] = try managedObjectContext.executeFetchRequest(request) as? [NVPStore] {
                //print(results.last)
                if let store = results.last  {
                    return store
                }
            }
        } catch {
            fatalError("Fetching from the store failed")
        }
        
        
       
        
        return nil
    }


}
