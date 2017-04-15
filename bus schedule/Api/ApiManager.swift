
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
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                            _ = vc.navigationController?.popToRootViewController(animated: true)
                            
                            listener.success()
                        } else {
                            let alert = UIAlertController(title: "Error", message: "Response isn`t success", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                            vc.present(alert, animated: true, completion: nil)
                            listener.parseError()
                        }
                        
        }, failure: { (operation, error) in
            let alert = UIAlertController(title: "error_title".localized, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "cancel_btn".localized, style: UIAlertActionStyle.cancel, handler: { action  in
                listener.success()
            }))
            alert.addAction(UIAlertAction(title: "try_again_btn".localized, style: UIAlertActionStyle.default, handler: { action in
                ApiManager.instance.loadData(listener: listener, url: url, dbManager: dbManager, vc: vc)
            }))
            vc.present(alert, animated: true, completion: nil)
        })
    }
    
    func createUrl(dateFrom: Date, dateTo: Date) -> String {
        return baseURL + modeFromDate + DateConverter.convertDateToStringForResponse(date: dateFrom) + modeToDate + DateConverter.convertDateToStringForResponse(date: dateTo)
    }
}
