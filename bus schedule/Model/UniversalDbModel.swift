
class UniversalDbModel {
    
    let coreDataModel: ScheduleItem?
    
    let realmModel: ScheduleItemRealm?
    
    init(withRealmModel: ScheduleItemRealm) {
        realmModel = withRealmModel
        coreDataModel = nil
    }
    
    init(withCoreDataModel: ScheduleItem) {
        coreDataModel = withCoreDataModel
        realmModel = nil
    }
 
    func getInfo() -> String {
        return (realmModel != nil ? realmModel?.info : coreDataModel?.info)!
    }
    
    func getFromInfo() -> String {
        return (realmModel != nil ? realmModel?.fromInfo : coreDataModel?.fromInfo)!
    }
    
    func getToInfo() -> String {
        return (realmModel != nil ? realmModel?.toInfo : coreDataModel?.toInfo)!
    }
    
    func getFromDate() -> Date {
        return (realmModel != nil ? realmModel?.fromDate : (coreDataModel?.fromDate as! Date))!
    }
    
    func getToDate() -> Date {
        return (realmModel != nil ? realmModel?.toDate : (coreDataModel?.toDate as! Date))!
    }
    
    func getPrice() -> Int {
        return (realmModel != nil ? realmModel?.price : Int((coreDataModel?.price)!))!
    }
    
    func getFromCityName() -> String {
        return (realmModel != nil ? realmModel?.fromCity?.name : coreDataModel?.fromCity?.name)!
    }
    
    func getToCityName() -> String {
        return (realmModel != nil ? realmModel?.toCity?.name : coreDataModel?.toCity?.name)!
    }
    
}
