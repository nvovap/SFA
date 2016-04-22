//
//  Product.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 24.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class Product: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var fullname: String
    @NSManaged var barcode: String
    @NSManaged var idGroup: String
    @NSManaged var code: String
    @NSManaged var order: NSNumber
    @NSManaged var artikle: String
    
    class func insertProduct(id _id: String, name: String, fullname: String, code: String, idGroup: String, barcode: String, artikle: String, order: Int) -> (Product!)  {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if var desc: NSEntityDescription = NSEntityDescription.entityForName("Product", inManagedObjectContext: managedObjectContext) {
                var product: Product = Product(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                product.id      = _id
                product.name    = name
                product.fullname = fullname
                product.code    = code
                product.idGroup = idGroup
                product.barcode = barcode
                product.artikle = artikle
                product.order   = order
                
                return product
            }
        }
        
        return nil
        
    
    }

}
