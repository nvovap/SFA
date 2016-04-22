//
//  NVPProductGroup.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 02.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPProductGroup)
class NVPProductGroup: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var fullname: String
    @NSManaged var idGroup: String
    @NSManaged var code: String
    @NSManaged var products: NSSet?
    @NSManaged var group: NVPProductGroup?
    @NSManaged var groups: NSSet?
    
    
    
    class func insertGroup(id _id: String, name: String, fullname: String, code: String, idGroup: String) -> (NVPProductGroup?)  {
        
        if let group = self.getGroup(id: _id) {
            group.name    = name
            group.fullname = fullname
            group.code    = code
            group.idGroup = idGroup
            
            if let group = NVPProductGroup.getGroup(id: idGroup) {
                
                group.group = group
            }
            return group
        }
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("ProductGroup", inManagedObjectContext: managedObjectContext) {
                let product: NVPProductGroup = NVPProductGroup(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                product.id      = _id
                product.name    = name
                product.fullname = fullname
                product.code    = code
                product.idGroup = idGroup
                if let group = NVPProductGroup.getGroup(id: idGroup) {
                    product.group = group
                }
                
                
                return product
            }
        }
        
        return nil
        
        
    }
    
    class func  getGroup(id _id: String) -> (NVPProductGroup?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "ProductGroup")
        
        let predicate = NSPredicate(format: "id == \""+_id+"\"")
        
        request.predicate = predicate
        
        do {
            if let results: [NVPProductGroup] = try managedObjectContext.executeFetchRequest(request) as? [NVPProductGroup] {
                if let group = results.last  {
                    return group
                }
                
            }
        } catch {
            fatalError("Fetching from the store failed")
        }
        
        do {
            if let results: [NVPProductGroup] = try managedObjectContext.executeFetchRequest(request) as? [NVPProductGroup] {
               
                if let group = results.last  {
                    return group
                }
                
            }
        } catch {
            fatalError("Fetching from the store failed")
        }
    
        return nil
    }

}
