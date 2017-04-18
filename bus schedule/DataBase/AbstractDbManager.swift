
protocol AbstractDbManager {
    
    func retrieveDataFromDb() -> [AbstractScheduleItem]
    
    func clearDb()
    
    func getItemById(id: String) -> AbstractScheduleItem?
    
    func saveScheduleItemsJsonToDb(data: NSArray)
    
    func deleteItemById(id: String)
}
