//
//  ResiduesCategory.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 24.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData

class ResiduesCategory: NSManagedObject {

    @NSManaged var quantity: NSNumber
    @NSManaged var idProduct: String
    @NSManaged var category: NSManagedObject

}
