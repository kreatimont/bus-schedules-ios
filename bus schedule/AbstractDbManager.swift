
protocol AbstractDbManager {
    
    func retrieveDataFromDb() -> [UniversalDbModel]
    
    func clearDb()
    
    func getItemById(id: String) -> UniversalDbModel?
    
    func saveJsonArrayToDb(data: NSArray)
    
}
