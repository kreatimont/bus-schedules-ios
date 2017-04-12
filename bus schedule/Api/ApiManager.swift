
import AFNetworking

class ApiManager {
    
    static let instance = ApiManager()
    
    let manager = AFHTTPSessionManager()
    
    let baseURL = "http://smartbus.gmoby.org/web/index.php/api/trips"
    let modeFromDate = "?from_date=", modeToDate = "&to_date="
    
    func loadData(listener: ApiListener, url: String, dbManager: AbstractDbManager, vc: UIViewController) {
        
        manager.get(url, parameters: nil, progress: nil,
                    success: { (operation, responseObject) in
                        
                        let responseData = responseObject as! NSDictionary
                        if(responseData["success"] != nil) {
                            
                            dbManager.saveJsonArrayToDb(data: responseData["data"] as! NSArray)
                            
                            listener.success()
                        } else {
                            let alert = UIAlertController(title: "Error", message: "Response isn`t success", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                            vc.present(alert, animated: true, completion: nil)
                        }
                        
        }, failure: { (operation, error) in
            /*Show error message*/
            listener.connectionError(error: error as NSError, url: url)
        })
    }
    
    func createUrl(dateFrom: Date, dateTo: Date) -> String {
        return baseURL + modeFromDate + DateConverter.convertDateToStringForResponse(date: dateFrom) + modeToDate + DateConverter.convertDateToStringForResponse(date: dateTo)
    }
}
