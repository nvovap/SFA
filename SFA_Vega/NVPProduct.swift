//
//  NVPProduct.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 02.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPProduct)
class NVPProduct: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var fullname: String
    @NSManaged var code: String
    @NSManaged var idGroup: String
    @NSManaged var artikle: String
    @NSManaged var barcode: String
    @NSManaged var order: NSNumber
    @NSManaged var numberPage: NSNumber    
    @NSManaged var contractPrice: NSNumber
    @NSManaged var group: NVPProductGroup?
    @NSManaged var idEd: String
    @NSManaged var nds: String
    @NSManaged var price1: NSNumber
    @NSManaged var price2: NSNumber
    @NSManaged var price3: NSNumber
    @NSManaged var price4: NSNumber
    
    
    class func insertProduct(id _id: String, name: String, fullname: String, code: String, idGroup: String, barcode: String, artikle: String, order: Int, numberPage: Int, contractPrice: Int, idEd: String, nds: String, price1: Double, price2: Double, price3: Double, price4: Double) -> (NVPProduct?)  {
        
        if let product = self.getProduct(id: _id) {
            product.name    = name
            product.fullname = fullname
            product.code    = code
            product.idGroup = idGroup
            
            product.artikle = artikle
            product.barcode = barcode
            
            product.order   = order
            product.numberPage   = numberPage
            product.contractPrice = contractPrice
            product.idEd    = idEd
            product.nds     = nds
            product.price1    = price1
            product.price2    = price2
            product.price3    = price3
            product.price4    = price4
            
            if let group = NVPProductGroup.getGroup(id: idGroup) {
                product.group = group
            }
            
            return product
        }
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("Product", inManagedObjectContext: managedObjectContext) {
                let product: NVPProduct = NVPProduct(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                product.id       = _id
                product.name     = name
                product.fullname = fullname
                product.code     = code
                product.idGroup  = idGroup
                product.artikle  = artikle
                product.barcode  = barcode
                product.order    = order
                product.numberPage   = numberPage
                product.contractPrice = contractPrice
                product.idEd      = idEd
                product.nds       = nds
                product.price1    = price1
                product.price2    = price2
                product.price3    = price3
                product.price4    = price4
                
                if let group = NVPProductGroup.getGroup(id: idGroup) {
                    product.group = group
                }
                
                
                return product
            }
        }
        
        return nil
        
        
    }
    
    class func  getProduct(id _id: String) -> (NVPProduct?) {
        
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        //var desc: NSEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
        
        let request = NSFetchRequest(entityName: "Product")
        
        let predicate = NSPredicate(format: "id == \""+_id+"\"")
        
        request.predicate = predicate
        
        do {
            if let results: [NVPProduct] = try managedObjectContext.executeFetchRequest(request) as? [NVPProduct] {
                if let product = results.last  {
                    return product
                }
                
            }
        } catch {
            fatalError("Fetching from the store failed")
        }

        return nil
    }
    
    
    class func getProducts(name: String!) -> ([NVPProduct]?)  {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            let request = NSFetchRequest(entityName: "Product")
            
            if let name = name {
                 let predicate = NSPredicate(format: "name like[c] '*"+name+"*'")
                
              //  var predicate = NSPredicate(format: "name CONTAINS '"+name+"'")
                
                
                request.predicate = predicate
            }
            
            
            let sortOrder = NSSortDescriptor(key: "order", ascending: true)
            
            request.sortDescriptors = [sortOrder]
            
            
            do {
                if let results: [NVPProduct] = try managedObjectContext.executeFetchRequest(request) as? [NVPProduct] {
                    return results
                }
            } catch {
                fatalError("Fetching from the store failed")
            }
        }
        
        return nil
        
        
    }

}
