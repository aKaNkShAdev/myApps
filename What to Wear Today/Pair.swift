//
//  Pair.swift
//  What to Wear Today
//
//  Created by Akanksha Sharma on 10/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import Foundation
import CoreData

class Pair: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var shirt_id: NSNumber
    @NSManaged var status: NSNumber
    @NSManaged var is_shared: NSNumber
    @NSManaged var jeans_id: NSNumber
    @NSManaged var jeansPath: NSString
    @NSManaged var shirtPath: NSString


}
