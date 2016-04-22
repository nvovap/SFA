//
//  Store.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 24.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class Store: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var code: String
    @NSManaged var name: String
    @NSManaged var idClient: String
   
    @NSManaged var adress: String
    @NSManaged var category: Category
    @NSManaged var client: Client
    
    
    class func insertStore(id _id: String, name: String, code: String,  idClient: String, category: String) -> (Store!)  {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if var desc: NSEntityDescription = NSEntityDescription.entityForName("Store", inManagedObjectContext: managedObjectContext) {
                var product: Store = Store(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                product.id        = _id
                product.name      = name
                product.code      = code
                product.idClient  = idClient
                product.adress    = code
                //product.client    = client
                product.category  = Category.getCategory(category)
                
                
                return product
            }
        }
        
        return nil
        
        
    }

}
