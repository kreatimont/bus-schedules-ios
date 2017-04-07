
import RealmSwift

class ScheduleCityRealm: Object {
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var highlight = 0
 
    override class func primaryKey() -> String {
        return "id"
    }
    
}
