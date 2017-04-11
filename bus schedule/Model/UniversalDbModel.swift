
protocol UniversalDbModel {
    
    func getInfo() -> String;
    
    func getFromInfo() -> String;
    
    func getToInfo() -> String;
    
    func getFromDate() -> Date;
    
    func getToDate() -> Date;
    
    func getPrice() -> Int;
    
    func getFromCityName() -> String;
    
    func getToCityName() -> String;
    
}
