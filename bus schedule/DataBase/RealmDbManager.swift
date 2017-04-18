

import RealmSwift

class RealmDbManager : AbstractDbManager {
    
    static let instance = RealmDbManager()
    
    var realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    
    //MARK: db manager implementation
    
    internal func retrieveDataFromDb() -> [AbstractScheduleItem] {
        return Array(realm.objects(ScheduleItemRealm.self).sorted(byKeyPath: "fromDate"))
    }
    
    internal func clearDb() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    internal func getItemById(id: String) -> AbstractScheduleItem? {
        return Array(realm.objects(ScheduleItemRealm.self).filter("id == \(id)")).first
    }
    
    internal func saveScheduleItemsJsonToDb(data: NSArray) {
        for dataItem in data {
            
            let currentItem = dataItem as! NSDictionary
            
            do {
                
                let currentFromCity = currentItem["from_city"] as! NSDictionary
                let currentToCity = currentItem["to_city"] as! NSDictionary
                
                try DispatchQueue(label: "realm").sync {
                    
                    try realm.write {
                        
                        let fromCity = realm.create(ScheduleCityRealm.self,
                                                    value: [
                                                        currentFromCity["id"],
                                                        currentFromCity["name"],
                                                        currentFromCity["highlight"]
                            ], update: true)
                        
                        let toCity = realm.create(ScheduleCityRealm.self,
                                                  value: [
                                                    currentToCity["id"],
                                                    currentToCity["name"],
                                                    currentToCity["highlight"]
                            ], update: true)
                        
                        
                        _ = realm.create(ScheduleItemRealm.self,
                                         value: [
                                            currentItem["id"],
                                            currentItem["bus_id"],
                                            currentItem["price"],
                                            currentItem["reservation_count"],
                                            currentItem["info"],
                                            currentItem["from_info"],
                                            currentItem["to_info"],
                                            DateConverter.createDateFromResponse(
                                                date: currentItem["from_date"] as! String, time: currentItem["from_time"] as! String),
                                            DateConverter.createDateFromResponse(
                                                date: currentItem["to_date"] as! String, time: currentItem["to_time"] as! String),
                                            fromCity,
                                            toCity
                            ], update: true)
                        
                    }
                    
                }
                
            } catch let error as NSError {
                print("\tData[\(currentItem["id"])] - NOT SAVED: \(error.localizedDescription); \n\t\t Full text error: \(error)")
            }
        }

    }
    
    internal func deleteItemById(id: String) {
        realm.beginWrite()
        if let object = realm.object(ofType: ScheduleItemRealm.self, forPrimaryKey: Int(id)) {
            realm.delete(object)
        }
        try! realm.commitWrite()
    }
}
