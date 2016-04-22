//
//  NVPResiduesCategory.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 25.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPResiduesCategory)
class NVPResiduesCategory: NSManagedObject {

    @NSManaged var idProduct: String
    @NSManaged var quantity: NSNumber
    @NSManaged var category: NVPCategory
    
    
    class func insertResiduesCategory(idProduct _id: String, quantity: NSNumber, category categoryName: String) -> (NVPResiduesCategory?)  {
        
        if let residuesCategory = self.getResiduesCategory(idProduct: _id, category: categoryName) {
            residuesCategory.quantity = quantity
            
            do {
                try residuesCategory.managedObjectContext?.save()
            } catch {
                fatalError("Fetching from the store failed")
            }
                     
            return residuesCategory
        }
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("ResiduesCategory", inManagedObjectContext: managedObjectContext) {
                let residuesCategory: NVPResiduesCategory = NVPResiduesCategory(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                residuesCategory.idProduct     = _id
                residuesCategory.quantity      = quantity
                residuesCategory.category      = NVPCategory.getCategory(categoryName)

                return residuesCategory
            }
        }
        
        return nil
    }
    
    
    
    class func  getResiduesCategory(idProduct _id: String, category categoryName: String) -> (NVPResiduesCategory?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "ResiduesCategory")
        
        let predicate = NSPredicate(format: "idProduct == '\(_id)' AND category.name == '\(categoryName)'")
        
        request.predicate = predicate
        
        do {
            if let results: [NVPResiduesCategory] = try managedObjectContext.executeFetchRequest(request) as? [NVPResiduesCategory] {
                
                //  print(results.last)
                
                
                if let residuesCategory = results.last  {
                    return residuesCategory
                }
                
                /* let category = NVPCategory.getCategory(categoryName)
                
                for residuesCategory in results {
                if residuesCategory.category == category {
                return residuesCategory
                }
                }*/
                
            }
        } catch {
            fatalError("Fetching from the store failed")
        }
        
        
        return nil
    }
    
  
}
