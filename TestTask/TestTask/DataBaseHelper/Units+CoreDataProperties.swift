//
//  Units+CoreDataProperties.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 01/10/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData


extension Units {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Units> {
        return NSFetchRequest<Units>(entityName: "Units")
    }

    @NSManaged public var apt: String?
    @NSManaged public var blockId: String?
    @NSManaged public var blockName: String?
    @NSManaged public var floor: String?
    @NSManaged public var id: String?
    @NSManaged public var propertyId: String?
    @NSManaged public var title: String?
    @NSManaged public var unitType: String?

}
