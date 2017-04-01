//
//  SetDateViewController.swift
//  BusSchedule
//
//  Created by admin on 3/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import AFNetworking
import CoreData

class SetDateViewController: UIViewController {

    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    
    let baseURL = "http://smartbus.gmoby.org/web/index.php/api/trips"
    let modeFromDate = "?from_date=", modeToDate = "&to_date="
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var loadedData: [ScheduleItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLoaderStub(state: false)
        
        //activity indicator configuration
        activityIndicator.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        activityIndicator.backgroundColor = UIColor.darkGray
        activityIndicator.layer.cornerRadius = 6.0
        activityIndicator.frame =
            .init(x: self.view.bounds.size.width/2 - 40, y: self.view.bounds.size.height/2 - 40, width: 80.0, height: 80.0)
    }

    @IBAction func setDate(_ sender: Any) {
        enableLoaderStub(state: true)
        loadData(url: baseURL + modeFromDate + DateHelper.convertDateToStringForResponse(date: fromDatePicker.date) + modeToDate + DateHelper.convertDateToStringForResponse(date: toDatePicker.date))
       
    }
    
    func enableLoaderStub(state: Bool) {
        
        if state {
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            self.navigationItem.hidesBackButton = true
            self.view.isUserInteractionEnabled = false
            self.btnSend.isEnabled = false
            self.fromDatePicker.isEnabled = false
            self.toDatePicker.isEnabled = false
        } else {
            
            activityIndicator.removeFromSuperview()
            activityIndicator.stopAnimating()
            
            self.navigationItem.hidesBackButton = false
            self.view.isUserInteractionEnabled = true
            self.btnSend.isEnabled = true
            self.fromDatePicker.isEnabled = true
            self.toDatePicker.isEnabled = true
        }
    }
    
    // MARK: Network
    func loadData(url: String) {
        
        print("Start loading url: \(url)")
        
        let manager = AFHTTPSessionManager()
        
        manager.get(url, parameters: nil, progress: nil,
                    success: { (operation, responseObject) in
                        
                        print("Load successed")
                        self.enableLoaderStub(state: false)
                        
                        let responseData = responseObject as! NSDictionary
                        if(responseData["success"] != nil) {
                            self.parseJson(data: responseData["data"] as! NSArray)
                        }
                    
                       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                       _ = self.navigationController?.popToRootViewController(animated: true)
                        
        }, failure: { (operation, Error) in
            self.enableLoaderStub(state: false)
            print("Error: " + Error.localizedDescription)
            
            let alert = UIAlertController(title: "Error", message: "Server not responding", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: { action in
                self.loadData(url: url)
            }))
            self.present(alert, animated: true, completion: nil)
        })

    }
    
    
    func parseJson(data: NSArray) {
        for dataItem in data {
            
            let tmpData = dataItem as! NSDictionary
            let fromCity = tmpData["from_city"] as! NSDictionary
            let toCity = tmpData["to_city"] as! NSDictionary
            
            print("\nProccess: \(tmpData["id"])")
            
            do {
                
                var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleItem")
                fetchRequest.fetchLimit = 1
                var idStr = String(describing: tmpData["id"])
                fetchRequest.predicate = NSPredicate(format: "id == %@", idStr)
                let items = try context.fetch(fetchRequest) as! [ScheduleItem]
                
                if(items.count == 0) {
                    
                    let newScheduleItem = NSEntityDescription.insertNewObject(forEntityName: "ScheduleItem", into: context)
                    
                    newScheduleItem.setValue(String(describing: tmpData["id"]) , forKey: "id")
                    newScheduleItem.setValue(tmpData["info"] as! String, forKey: "info")
                    newScheduleItem.setValue(tmpData["price"], forKey: "price")
                    newScheduleItem.setValue(DateHelper.convertStringToDate(string: tmpData["from_date"] as! String), forKey: "from_date")
                    newScheduleItem.setValue(DateHelper.convertStringToDate(string: tmpData["to_date"] as! String), forKey: "to_date")
                    newScheduleItem.setValue(tmpData["from_time"],forKey: "from_time")
                    newScheduleItem.setValue(tmpData["to_time"],forKey: "to_time")
                    newScheduleItem.setValue(tmpData["from_info"], forKey: "from_info")
                    newScheduleItem.setValue(tmpData["to_info"], forKey: "to_info")
                    
                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
                    idStr = String(describing: fromCity["name"])
                    fetchRequest.predicate = NSPredicate(format: "name == %@", idStr)
                    let fromCities = try context.fetch(fetchRequest) as! [City]
                    
                    if(fromCities.count > 0) {
                        print("\tCity \(fromCities[0].name) already existed")
                        newScheduleItem.setValue(fromCities[0], forKey: "from_city")
                    } else {
                        let newFromCity = NSEntityDescription.insertNewObject(forEntityName: "City", into: context)
                        newFromCity.setValue(fromCity["name"], forKey: "name")
                        newFromCity.setValue(fromCity["highlight"], forKey: "highlight")
                        print("\tNew city created = \(fromCity["name"])")
                        newScheduleItem.setValue(newFromCity, forKey: "from_city")
                        print("\t\tNew from city added to item  = \(newFromCity.value(forKey: "name"))")
                    }
                    
                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
                    idStr = String(describing: toCity["name"])
                    fetchRequest.predicate = NSPredicate(format: "name == %@", idStr)
                    let toCities = try context.fetch(fetchRequest) as! [City]
                    
                    if(toCities.count > 0) {
                        print("\tCity \(toCities[0].name) already existed")
                        newScheduleItem.setValue(toCities[0], forKey: "to_city")
                    } else {
                        let newToCity = NSEntityDescription.insertNewObject(forEntityName: "City", into: context)
                        newToCity.setValue(toCity["name"], forKey: "name")
                        newToCity.setValue(toCity["highlight"], forKey: "highlight")
                        print("\tNew city created = \(toCity["name"])")
                        newScheduleItem.setValue(newToCity, forKey: "to_city")
                        print("\t\tNew to city added to item  = \(newToCity.value(forKey: "name"))")
                    }
                    
                    print("\tData[\(tmpData["id"])] - Before context.save()")
                    try context.save()
                    loadedData.append(newScheduleItem as! ScheduleItem)
                    print("\tData[\(tmpData["id"])] - SAVED")
                    
                } else {
                    print("\tData[\(tmpData["id"])] - already exist, count: \(items.count), first: \(items[0].info)")
                }
                
            } catch let error as NSError {
                print("\tData[\(tmpData["id"])] - NOT SAVED: \(error.localizedDescription); \n\t\t Full text error: \(error)")
            }
            
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
