
import AFNetworking

class ApiManager {
    
    enum ApiEntity {
        case trips
        case cities
    }
    
    static let instance = ApiManager()
    
    let manager = AFHTTPSessionManager()
    
    let baseURL = "http://smartbus.gmoby.org/web/index.php/api", modeFromDate = "?from_date=", modeToDate = "&to_date="

    func loadScheduleItems(dateFrom: Date, dateTo: Date, listener: ApiListener, dbManager: AbstractDbManager, vc: BaseViewController) {

        dbManager.clearDb()
        
        manager.get(createUrl(dateFrom: dateFrom, dateTo: dateTo, entity: ApiEntity.trips), parameters: nil, progress: nil,
                    success: { (operation, responseObject) in
                        
                        let responseData = responseObject as! NSDictionary
                        if(responseData["success"] != nil) {
                            dbManager.saveScheduleItemsJsonToDb(data: responseData["data"] as! NSArray)
                            listener.responseSuccessed()
                        } else {
                            self.handleFailureResponse(listener: listener, vc: vc)
                        }
                        
        }, failure: { (operation, error) in
            self.handleConnectionError(error: error, listener: listener, vc: vc)
        })
    }
        
    func handleFailureResponse(listener: ApiListener, vc: BaseViewController) {
        vc.displayResponseErrorAlert()
        listener.responseFailed()
    }
    
    func handleConnectionError(error: Error, listener: ApiListener, vc: BaseViewController) {
        vc.displayConnectionErrorAlert(error: error)
        listener.responseFailed()
    }
    
    func createUrl(dateFrom: Date, dateTo: Date, entity: ApiEntity) -> String {
        var requestUrl = baseURL;
        switch entity {
            case ApiEntity.trips:
                requestUrl.append("/trips")
            case ApiEntity.cities:
                requestUrl.append("/cities")
        }
        return requestUrl + modeFromDate + DateConverter.convertDateToStringForResponse(date: dateFrom) + modeToDate + DateConverter.convertDateToStringForResponse(date: dateTo)
    }
}
