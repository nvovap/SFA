//
//  NVPInfoStory.swift
//  Vega3
//
//  Created by Владимир Невинный on 07.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(NVPInfoStory)
class NVPInfoStory: NSManagedObject {

    @NSManaged var info: String
    @NSManaged var store: NVPStore
    
    
    class func insertInfo(store _store: NVPStore, info: String) -> (NVPInfoStory?)  {
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
            if let desc: NSEntityDescription = NSEntityDescription.entityForName("InfoStore", inManagedObjectContext: managedObjectContext) {
                let infoStory: NVPInfoStory = NVPInfoStory(entity: desc, insertIntoManagedObjectContext: managedObjectContext)
                
                infoStory.store  = _store
                infoStory.info   = info
                
                
                return infoStory
            }
        }
        
        return nil
    }
    
    
    class func getInfos() -> ([NVPInfoStory]?)  {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            let request = NSFetchRequest(entityName: "InfoStore")
            
            
            
            do {
                if let results: [NVPInfoStory] = try managedObjectContext.executeFetchRequest(request) as? [NVPInfoStory] {
                    return results
                    
                    
                }
            } catch {
                fatalError("Fetching from the store failed")
            }
            
            
            
            
        }
        
        return nil
        
        
    }

}
