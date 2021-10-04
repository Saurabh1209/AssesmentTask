//
//  BuildingBlockModel.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 30/09/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//

import Foundation
import SwiftyJSON


// MARK: - UrineListElement
struct BuildingBlockModel{
    var blockName: String?
    var units: [Unit]?
    
        init(json:JSON) {
            self.blockName = json["block_name"].stringValue
            let arr = json["units"].arrayValue
            self.units = arr.compactMap({ (data) -> Unit? in
                return Unit.init(json: JSON.init(data))
            })
        }

}

// MARK: - Unit
struct Unit{
    var propertyID, apt: String?
    var activities: [Activity]?
    var unitType: String?
    var id, title: String?
    var blockID: String?
    var floor: String?
    var blockName: String?
    
    
    init(json:JSON) {
        self.propertyID = json["property_id"].stringValue
        self.apt = json["apt"].stringValue
        let arr = json["activities"].arrayValue
        self.activities = arr.compactMap({ (data) -> Activity? in
            return Activity.init(json: JSON.init(data))
        })
        self.unitType = json["unit_type"].stringValue
        self.id = json["id"].stringValue
        self.title = json["title"].stringValue
        self.blockID = json["block_id"].stringValue
        self.floor = json["floor"].stringValue
        self.blockName = json["block_name"].stringValue
        
    }
    
    init(unit: Units, activities:[Activities]) {
        self.apt = unit.apt
        self.blockID = unit.blockId
        self.blockName = unit.blockName
        self.floor = unit.floor
        self.id = unit.id
        self.propertyID = unit.propertyId
        self.title = unit.title
        self.unitType = unit.unitType
        
        self.activities = activities.compactMap({ (data) -> Activity? in
            return Activity(activity: data)
        })
    }
}


// MARK: - Activity
struct Activity{
    var progress: Int?
    var stepName, wf: String?
    var activityStatus: String?
    var activityName, id: String?
    var currentUserName: String?
    
    
    init(json:JSON) {
           self.progress = json["progress"].intValue
           self.stepName = json["step_name"].stringValue
           self.wf = json["wf"].stringValue
           self.activityStatus = json["activity_status"].stringValue
           self.activityName = json["activity_name"].stringValue
           self.id = json["id"].stringValue
           self.currentUserName = json["current_user_name"].stringValue
       }
    
    init(activity: Activities) {
        self.progress = Int(activity.progress)
        self.activityName = activity.activityName
        self.activityStatus = activity.activityStatus
        self.currentUserName = activity.currentUserName
        self.id = activity.id
        self.stepName = activity.stepName
    }

}
