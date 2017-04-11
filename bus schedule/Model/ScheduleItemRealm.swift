
import RealmSwift

class ScheduleItemRealm: Object, AbstractScheduleItem {
    
    dynamic var id = 0
    
    dynamic var busId = 0
    dynamic var price = 0
    dynamic var reservationCount = 0
    
    dynamic var info = ""
    dynamic var fromInfo = ""
    dynamic var toInfo = ""
    
    dynamic var fromDate = Date()
    dynamic var toDate = Date()
    
    dynamic var fromCity: ScheduleCityRealm?
    dynamic var toCity: ScheduleCityRealm?
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    //MARK: AbstractModel implementation
    
    internal func getId() -> Int {
        return self.id
    }
    
    internal func getBusId() -> Int {
        return self.busId
    }
    
    internal func getPrice() -> Int {
        return self.price
    }
    
    internal func getReservationCount() -> Int {
        return self.reservationCount
    }
    
    internal func getInfo() -> String {
        return self.info
    }
    
    internal func getFromInfo() -> String {
        return self.fromInfo
    }
    
    internal func getToInfo() -> String {
        return self.toInfo
    }
    
    internal func getFromDate() -> Date {
        return self.fromDate
    }
    
    internal func getToDate() -> Date {
        return self.toDate
    }
    
    internal func getFromCity() -> AbstractScheduleCity {
        return self.fromCity!
    }
    
    internal func getToCity() -> AbstractScheduleCity {
        return self.toCity!
    }
    
}
