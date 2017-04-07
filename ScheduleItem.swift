
import RealmSwift

class ScheduleItemRealm: Object {
    
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
    
}
