//
//  Cloth.swift
//  What to Wear Today
//
//  Created by Akanksha Sharma on 10/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import Foundation
import CoreData

class Cloth: NSManagedObject {

    @NSManaged var img_path: String
    @NSManaged var type_id: NSNumber
    @NSManaged var cloth_id: NSNumber

}
