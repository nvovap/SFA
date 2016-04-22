//
//  NVPSectionOrder.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 02.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPSectionOrder)
class NVPSectionOrder: NSManagedObject {

    @NSManaged var idProduct: String
    @NSManaged var orderProduct: NSNumber
    @NSManaged var numberPage: NSNumber    
    @NSManaged var residue: NSNumber
    @NSManaged var quantity: NSNumber
    @NSManaged var price: NSNumber
    @NSManaged var order: NVPOrder?
    
    
    
    class func insertSectionOrder(product _product: NVPProduct, order: NVPOrder, residue: Double, quantity: Double, price: Double) -> (NVPSectionOrder?)  {
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("SectionOrder", inManagedObjectContext: managedObjectContext) {
                let section: NVPSectionOrder = NVPSectionOrder(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                section.idProduct       = _product.id
                section.orderProduct    = _product.order
                section.residue         = residue
                section.quantity        = quantity
                section.price           = price
                section.order           = order
                
                
                return section
            }
        }
        
        return nil
    }


}
