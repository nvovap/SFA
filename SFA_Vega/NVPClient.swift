//
//  NVPClient.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 25.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPClient)
class NVPClient: NSManagedObject {

    @NSManaged var code: String
    @NSManaged var fullname: String
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var okpo: String
    @NSManaged var outlets: NSSet
    @NSManaged var summa1: NSNumber
    @NSManaged var summa2: NSNumber
    
    
    class func insertStore(id _id: String, name: String, fullname: String, code: String, okpo: String) -> (NVPClient?)  {
        
        if let client = self.getClient(id: _id) {
            client.name      = name
            client.code      = code
            client.fullname  = fullname
            client.okpo      = okpo
            client.summa1    = 0
            client.summa2    = 0
            
            return client
        }
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("Client", inManagedObjectContext: managedObjectContext) {
                let client: NVPClient = NVPClient(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                client.id        = _id
                client.name      = name
                client.code      = code
                client.fullname  = fullname
                client.okpo      = okpo
                client.summa1    = 0
                client.summa2    = 0
                
                
                return client
            }
        }
        
        return nil
        
        
    }
    
    
    class func  getClient(id _id: String) -> (NVPClient?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Client")
        
        let predicate = NSPredicate(format: "id == \""+_id+"\"")
        
        request.predicate = predicate
        
        do {
            if let results: [NVPClient] = try managedObjectContext.executeFetchRequest(request) as? [NVPClient] {
                
                if let client = results.last  {
                    return client
                }
                
            }
        } catch {
            fatalError("Fetching from the store failed")
        }
        
        
        
         return nil
    }
    
    class func getClients(name: String!) -> ([NVPClient]?)  {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            let request = NSFetchRequest(entityName: "Client")
            
            if let name = name {
                let predicate = NSPredicate(format: "fullname like[c] '*"+name+"*'")
                request.predicate = predicate
                
                
            }
            
            
            let sortOrder = NSSortDescriptor(key: "name", ascending: true)
            
            request.sortDescriptors = [sortOrder]
            
            do {
                if let results: [NVPClient] = try managedObjectContext.executeFetchRequest(request) as? [NVPClient] {
                    return results
                    
                    
                }
            } catch {
                fatalError("Fetching from the store failed")
            }
            
            
            
            
        }
        
        return nil
        
        
    }


}
