//
//  NVPCategory.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 26.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPCategory)
class NVPCategory: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var outlets: NSSet?
    @NSManaged var residues: NSSet?
    
    class func  getCategory(name: String) -> (NVPCategory) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Category")
        
        let predicate = NSPredicate(format: "name == \""+name+"\"")
        
        request.predicate = predicate
        
        
        do {
            if let results: [NVPCategory] = try managedObjectContext.executeFetchRequest(request) as? [NVPCategory] {
                if let category = results.last  {
                    return category
                }
            }
        } catch {
            fatalError("Fetching from the store failed")
        }
        
        
        
        let desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        let category: NVPCategory = NVPCategory(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
        
        category.name    = name
        
        
        return category
    }


}
