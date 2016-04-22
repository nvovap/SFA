//
//  NVPSectionSalesForBonus.swift
//  sfa_vega
//
//  Created by nvovap on 2/25/16.
//  Copyright © 2016 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPSectionSalesForBonus)
class NVPSectionSalesForBonus: NSManagedObject {

    class func insertSectionSalesForBonus(product _product: NVPProduct, salesForBonus: NVPSalesForBonus,  quantity: Double) -> (NVPSectionSalesForBonus?)  {
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("SectionSalesForBonus", inManagedObjectContext: managedObjectContext) {
                let section: NVPSectionSalesForBonus = NVPSectionSalesForBonus(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                section.idProduct     = _product.id
                section.quantity      = quantity
                section.salesForBonus = salesForBonus
                
                
                return section
            }
        }
        
        return nil
    }

}


extension NVPSectionSalesForBonus {
    
    @NSManaged var idProduct: String
    @NSManaged var quantity: NSNumber
    @NSManaged var salesForBonus: NVPSalesForBonus?
    
}
