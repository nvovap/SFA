//
//  Client.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 24.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import CoreData

class Client: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var fullname: String
    @NSManaged var code: String
    @NSManaged var okpo: String
    @NSManaged var outlets: NSSet

}
