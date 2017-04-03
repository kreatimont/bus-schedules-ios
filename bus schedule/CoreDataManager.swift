//
//  CoreDataManager.swift
//  bus schedule
//
//  Created by admin on 4/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static var instance: CoreDataManager? = nil
    
    static func getInstance() -> CoreDataManager {
        if(instance == nil) {
            instance = CoreDataManager()
        }
        return instance!
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveJsonArrayToDB(data: NSArray) {
        for dataItem in data {
            
            let tmpData = dataItem as! NSDictionary
            let fromCity = tmpData["from_city"] as! NSDictionary
            let toCity = tmpData["to_city"] as! NSDictionary
            
            do {
                
                var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleItem")
                fetchRequest.fetchLimit = 1
                var idStr = String(describing: tmpData["id"])
                fetchRequest.predicate = NSPredicate(format: "id == %@", idStr)
                
                let items = try context.fetch(fetchRequest) as! [ScheduleItem]
                
                if(items.count == 0) {
                    let newScheduleItem = NSEntityDescription.insertNewObject(forEntityName: "ScheduleItem", into: context)
                    
                    newScheduleItem.setValue(String(describing: tmpData["id"]) , forKey: "id")
                    newScheduleItem.setValue(tmpData["info"] as! String, forKey: "info")
                    newScheduleItem.setValue(tmpData["price"], forKey: "price")
                    newScheduleItem.setValue(DateHelper.convertStringToDate(string: tmpData["from_date"] as! String), forKey: "from_date")
                    newScheduleItem.setValue(DateHelper.convertStringToDate(string: tmpData["to_date"] as! String), forKey: "to_date")
                    newScheduleItem.setValue(tmpData["from_time"],forKey: "from_time")
                    newScheduleItem.setValue(tmpData["to_time"],forKey: "to_time")
                    newScheduleItem.setValue(tmpData["from_info"], forKey: "from_info")
                    newScheduleItem.setValue(tmpData["to_info"], forKey: "to_info")
                    
                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
                    idStr = String(describing: fromCity["name"])
                    fetchRequest.predicate = NSPredicate(format: "name == %@", idStr)
                    
                    let fromCities = try context.fetch(fetchRequest) as! [City]
                    
                    if(fromCities.count > 0) {
                        newScheduleItem.setValue(fromCities[0], forKey: "from_city")
                    } else {
                        let newFromCity = NSEntityDescription.insertNewObject(forEntityName: "City", into: context)
                        newFromCity.setValue(fromCity["name"], forKey: "name")
                        newFromCity.setValue(fromCity["highlight"], forKey: "highlight")
                        newScheduleItem.setValue(newFromCity, forKey: "from_city")
                    }
                    
                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
                    idStr = String(describing: toCity["name"])
                    fetchRequest.predicate = NSPredicate(format: "name == %@", idStr)
                    
                    let toCities = try context.fetch(fetchRequest) as! [City]
                    
                    if(toCities.count > 0) {
                        newScheduleItem.setValue(toCities[0], forKey: "to_city")
                    } else {
                        let newToCity = NSEntityDescription.insertNewObject(forEntityName: "City", into: context)
                        newToCity.setValue(toCity["name"], forKey: "name")
                        newToCity.setValue(toCity["highlight"], forKey: "highlight")
                        newScheduleItem.setValue(newToCity, forKey: "to_city")
                    }
                    
                    try context.save()
                } else {
                    print("\tData[\(tmpData["id"])] - already exist, count: \(items.count), info: \(items[0].info)")
                }
            } catch let error as NSError {
                print("\tData[\(tmpData["id"])] - NOT SAVED: \(error.localizedDescription); \n\t\t Full text error: \(error)")
            }
        }
    }
    
    func getScheduleItemById(id: String) -> ScheduleItem? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleItem")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            return (try context.fetch(fetchRequest) as! [ScheduleItem])[0]
        } catch let error as NSError {
            print("Detailed obj was not loaded, errer: \(error)")
        }
        return nil
    }
    
    func clearDb() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleItem")
        let result = try? context.fetch(fetchRequest)
        for object in result! {
            context.delete(object as! NSManagedObject)
        }
        let fetchRequestCity = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let resultCity = try? context.fetch(fetchRequestCity)
        for object in resultCity! {
            context.delete(object as! NSManagedObject)
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Database was not cleared, error: \(error)")
        }
    }
    
    func retrieveDataFromDb() -> [ScheduleItem] {
        do {
            let fetch: NSFetchRequest = ScheduleItem.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "from_date", ascending: true)
            fetch.sortDescriptors = [sortDescriptor]
            return try context.fetch(fetch)
        } catch let error as NSError {
            print("Data was not retrieved, error: \(error.localizedDescription)")
        }
        return []
    }
    
}
