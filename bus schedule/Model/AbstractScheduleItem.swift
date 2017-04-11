
protocol AbstractScheduleItem {
    
    func getId() -> Int
    
    func getBusId() -> Int
    
    func getPrice() -> Int
    
    func getReservationCount() -> Int
    
    func getInfo() -> String
    
    func getFromInfo() -> String
    
    func getToInfo() -> String
    
    func getFromDate() -> Date
    
    func getToDate() -> Date
    
    func getFromCity() -> AbstractScheduleCity
    
    func getToCity() -> AbstractScheduleCity

}
