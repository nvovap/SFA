//
//  NVPSectionInvet.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 26.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit


@objc(NVPSectionInvet)
class NVPSectionInvet: NSManagedObject {

    
    @NSManaged var idProduct: String
    @NSManaged var nameProduct: String
    @NSManaged var order: NSNumber
    @NSManaged var quantityCategory: NSNumber
    @NSManaged var factResidue: NSNumber
    @NSManaged var residue: NSNumber
    @NSManaged var inventory: NVPInventory?
    
    
    class func insertSectionInventory(residuesCategory residues: NVPResiduesCategory, inventory: NVPInventory) -> (NVPSectionInvet?)  {
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("SectionInvet", inManagedObjectContext: managedObjectContext) {
                let inventorySection: NVPSectionInvet = NVPSectionInvet(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                
                inventorySection.idProduct = residues.idProduct
                
                if let product = NVPProduct.getProduct(id: residues.idProduct) {
                    inventorySection.nameProduct = product.name
                    inventorySection.order       = product.order
                }
                
                //получить остаток для торговой точки по номенклатуре
                
                
                
                inventorySection.factResidue = 0
                inventorySection.residue     = 0
                
                inventorySection.quantityCategory = residues.quantity
                
                
                inventorySection.inventory = inventory
                
                return inventorySection
            }
        }
        
        return nil
    }
    
    
    class func insertSectionInventory(product _product: NVPProduct, inventory: NVPInventory) -> (NVPSectionInvet?)  {
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("SectionInvet", inManagedObjectContext: managedObjectContext) {
                let inventorySection: NVPSectionInvet = NVPSectionInvet(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                
                inventorySection.idProduct   = _product.id
                inventorySection.nameProduct = _product.name
                inventorySection.order       = _product.order
                
                
                //получить остаток для торговой точки по номенклатуре
                
                inventorySection.factResidue = 1
                inventorySection.residue     = 0
                
                inventorySection.quantityCategory = 0
                
                
                inventorySection.inventory = inventory
                
                return inventorySection
            }
        }
        
        return nil
    }

}
