//
//  Category.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 24.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var residues: NSSet
    @NSManaged var stores: NSSet
    
    
    class func  getCategory(name: String) -> (Category) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        var request = NSFetchRequest(entityName: "Category")
        
        var predicate = NSPredicate(format: "name == \""+name+"\"")
        
        request.predicate = predicate
        
        
        let results: NSArray = managedObjectContext.executeFetchRequest(request, error: nil)!
        
        if let results: NSArray = managedObjectContext.executeFetchRequest(request, error: nil)  {
            
            print(results.lastObject)
            
            // let cc: Category = results.lastObject
            
            if let category = results.lastObject as? Category {
                return category
            }
            
        }
        
        //if let results = _results {
        
        
        var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        var category: Category = Category(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
        
        category.name    = name
        
        
        return category
    }

}
