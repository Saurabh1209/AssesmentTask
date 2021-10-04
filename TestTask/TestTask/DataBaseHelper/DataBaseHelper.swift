//
//  DataBaseHelper.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 30/09/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON

typealias ResponseCompletion = ([Units]?, [Activities]?)->Void
let appdelegate = UIApplication.shared.delegate as! AppDelegate

class DataBaseHelper: NSObject {
    static var shared = DataBaseHelper()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let concurrentQueue = DispatchQueue(label: "saveQueue", qos: .userInitiated, attributes: [.concurrent], autoreleaseFrequency: .workItem, target: nil)
    
    final func insertUnitDetail(units:[Unit]) {
        self.saveUnitDetail(units: units)
     }
     
     //For saving the detail in CoreData
     func saveUnitDetail(units:[Unit]) {
        self.concurrentQueue.async {
            units.forEach { (unit) in

               let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Units")
               request.predicate = NSPredicate(format: "id = %@", "\(unit.id ?? "")")
               
               do {
                   let result = try self.managedObjectContext.fetch(request)
                   if let objectData = result.first as? Units {
                       objectData.apt = unit.apt
                       objectData.blockId = unit.blockID
                       objectData.blockName = unit.blockName
                       objectData.floor = unit.floor
                       objectData.propertyId = unit.propertyID
                       objectData.title = unit.title
                       objectData.unitType = unit.unitType
                       
                    unit.activities?.forEach { (activity) in
                            let activityrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activities")
                            activityrequest.predicate = NSPredicate(format: "id = %@", "\(activity.id ?? "")")
                            activityrequest.returnsObjectsAsFaults = false

                            do {
                                let result = try self.managedObjectContext.fetch(request)
                                if let objectData = result.first as? Activities {
                                    objectData.activityName = activity.activityName
                                    objectData.activityStatus = activity.activityStatus
                                    objectData.id = activity.id
                                    objectData.unitsId = unit.id
                                    objectData.stepName = activity.stepName
                                    objectData.progress = Int16.init("\(activity.progress ?? 0)") ?? 0
                                    objectData.currentUserName = activity.currentUserName
                                    //objectData.wf = activity.wf
                                }
                            }
                            catch {
                                print("Failed")
                            }
                        }
                       
                   } else {
                        let unitEntity = NSEntityDescription.insertNewObject(forEntityName: "Units", into: self.managedObjectContext) as? Units
                        unitEntity?.apt = unit.apt
                        unitEntity?.blockId = unit.blockID
                        unitEntity?.blockName = unit.blockName
                        unitEntity?.floor = unit.floor
                        unitEntity?.id = unit.id
                        unitEntity?.propertyId = unit.propertyID
                        unitEntity?.title = unit.title
                        unitEntity?.unitType = unit.unitType
                       
                    unit.activities?.forEach { (activity) in
                            let activityEntity1 = NSEntityDescription.insertNewObject(forEntityName: "Activities", into: self.managedObjectContext) as? Activities
                            activityEntity1?.activityName = activity.activityName
                            activityEntity1?.activityStatus = activity.activityStatus
                            activityEntity1?.id = activity.id
                            activityEntity1?.unitsId = unit.id
                            activityEntity1?.stepName = activity.stepName
                            activityEntity1?.progress = Int16.init("\(activity.progress ?? 0)") ?? 0
                            activityEntity1?.currentUserName = activity.currentUserName
                            //ctivityEntity1?.wf = activity.wf
                            appdelegate.saveContext()
                        }
                    appdelegate.saveContext()
                   }
               } catch {
                   print("Error while saving data")
               }
            }
            appdelegate.saveContext()

        }
     }
    
     func clearDataBase () {
         self.deleteUser()
     }
     fileprivate func deleteUser () {
         
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
         do {
             let result = try self.managedObjectContext.fetch(request)
             for data in result as! [NSManagedObject] {
                 self.managedObjectContext.delete(data)
             }
             appdelegate.saveContext()
         } catch {
             print("Error while deleting user")
         }
     }
    public func searchUnitData (searchText: String, completion:@escaping ResponseCompletion) {
      
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Units")
        request.predicate = NSPredicate(format: "title contains[c] %@", "\(searchText)")
        request.returnsObjectsAsFaults = false
        var allactivities = [Activities]()
        do {
            
            let result = try self.managedObjectContext.fetch(request)
            if let detail = result as? [Units] {
                detail.forEach { (unit) in
                    allactivities.append(contentsOf: self.getAllActivitiesForUnitID(unit: unit) ?? [])
                }
                completion(detail, allactivities)
            }
            
        } catch {
            
            print("Error while search unit data")
            completion(nil,nil)
        }
        
    }
    public func getAllActivitiesForUnitID (unit: Units) -> ([Activities]?) {
      
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activities")
        request.predicate = NSPredicate(format: "unitsId = %@", "\(unit.id ?? "")")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let result = try self.managedObjectContext.fetch(request)
            if let detail = result as? [Activities] {
                return detail
            }
            
        } catch {
            
            print("Error while get data")
            return nil
        }
        
        return nil
    }
    
    public func searchActivitiesData (searchText: String, completion:@escaping ResponseCompletion) {
      
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activities")
        let predicate1 = NSPredicate(format: "activityName contains[c] %@", "\(searchText)")
        let predicate2 = NSPredicate(format: "stepName contains[c] %@", "\(searchText)")
        request.predicate = NSCompoundPredicate(type: .or, subpredicates: [predicate1, predicate2])
        request.returnsObjectsAsFaults = false
        var allUnits = [Units]()
        do {
            
            let result = try self.managedObjectContext.fetch(request)
            if let detail = result as? [Activities] {
                detail.forEach { (activity) in
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Units")
                    request.predicate = NSPredicate(format: "id = %@", "\(activity.unitsId ?? "")")
                    
                    do {
                        let result = try self.managedObjectContext.fetch(request)
                        if let objectData = result as? [Units] {
                            allUnits.append(contentsOf: objectData)
                        }
                    }
                    catch {
                        print("Error while search data")
                    }
                }
                completion(allUnits, detail)
            }
        } catch {
            print("Error while search data")
            completion(nil,nil)
        }
    }
    
    
    
}
