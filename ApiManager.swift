
import AFNetworking

class ApiManager {
    
    static let instance = ApiManager()
    
    let manager = AFHTTPSessionManager()
    
    let baseURL = "http://smartbus.gmoby.org/web/index.php/api/trips"
    let modeFromDate = "?from_date=", modeToDate = "&to_date="
    
    func loadData(listener: ApiListener, url: String) {
        
        manager.get(url, parameters: nil, progress: nil,
                    success: { (operation, responseObject) in
                        
                        let responseData = responseObject as! NSDictionary
                        if(responseData["success"] != nil) {
                            CoreDataManager.instance.saveJsonArrayToDB(data: responseData["data"] as! NSArray)
                            listener.success()
                        } else {
                            listener.parseError()
                        }
                        
        }, failure: { (operation, Error) in
            listener.connectionError(error: Error as NSError, url: url)
        })
    }
    
    func createUrl(dateFrom: Date, dateTo: Date) -> String {
        return baseURL + modeFromDate + DateConverter.convertDateToStringForResponse(date: dateFrom) + modeToDate + DateConverter.convertDateToStringForResponse(date: dateTo)
    }
}
