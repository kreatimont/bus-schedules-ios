
protocol AbstractDbManager {
    
    func retrieveDataFromDb() -> [AbstractScheduleItem]
    
    func clearDb()
    
    func getItemById(id: String) -> AbstractScheduleItem?
    
    func saveJsonArrayToDb(data: NSArray)
    
}
