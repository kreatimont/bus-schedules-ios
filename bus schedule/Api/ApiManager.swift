
import AFNetworking

class ApiManager {
    
    static let instance = ApiManager()
    
    let manager = AFHTTPSessionManager()
    
    let baseURL = "http://smartbus.gmoby.org/web/index.php/api/"
    let modeFromDate = "?from_date=", modeToDate = "&to_date="
    
    func loadScheduleItems(listener: ApiListener, url: String, dbManager: AbstractDbManager, vc: UIViewController) {
        
        manager.get(url + "/trips", parameters: nil, progress: nil,
                    success: { (operation, responseObject) in
                        
                        let responseData = responseObject as! NSDictionary
                        if(responseData["success"] != nil) {
                            
                            dbManager.saveScheduleItemsJsonToDb(data: responseData["data"] as! NSArray)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                            _ = vc.navigationController?.popToRootViewController(animated: true)
                            
                            listener.success()
                        } else {
                            self.handleFailureResponse(listener: listener, vc: vc)
                        }
                        
        }, failure: { (operation, error) in
            self.handleNetworkFailure(error: error, listener: listener, vc: vc, dbManager: dbManager)
        })
    }
    
    func handleSuccessResponse() {
        
    }
    
    func handleFailureResponse(listener: ApiListener, vc: UIViewController) {
        let alert = UIAlertController(title: "Error", message: "Response isn`t success", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        listener.parseError()
    }
    
    func handleNetworkFailure(error: Error, listener: ApiListener, vc: UIViewController, dbManager: AbstractDbManager) {
        let alert = UIAlertController(title: "error_title".localized, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "cancel_btn".localized, style: UIAlertActionStyle.cancel, handler: { action  in
            listener.success()
        }))
        /*alert.addAction(UIAlertAction(title: "try_again_btn".localized, style: UIAlertActionStyle.default, handler: { action in
            ApiManager.instance.loadData(listener: listener, url: url, dbManager: dbManager, vc: vc)
        }))*/
        vc.present(alert, animated: true, completion: nil)

    }
    
    func createUrl(dateFrom: Date, dateTo: Date) -> String {
        return baseURL + modeFromDate + DateConverter.convertDateToStringForResponse(date: dateFrom) + modeToDate + DateConverter.convertDateToStringForResponse(date: dateTo)
    }
}
