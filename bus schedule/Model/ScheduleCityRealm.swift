
import RealmSwift

class ScheduleCityRealm: Object, AbstractScheduleCity {
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var highlight = 0
 
    override class func primaryKey() -> String {
        return "id"
    }
    
    internal func getName() -> String {
        return self.name
    }
    
    internal func getHighlight() -> Int {
        return self.highlight
    }
    
}
