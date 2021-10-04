//
//  Activities+CoreDataProperties.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 01/10/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData


extension Activities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activities> {
        return NSFetchRequest<Activities>(entityName: "Activities")
    }

    @NSManaged public var activityName: String?
    @NSManaged public var activityStatus: String?
    @NSManaged public var currentUserName: String?
    @NSManaged public var id: String?
    @NSManaged public var progress: Int16
    @NSManaged public var stepName: String?
    @NSManaged public var unitsId: String?
    @NSManaged public var wf: String?

}
