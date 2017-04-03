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
                            CoreDataManager.getInstance().saveJsonArrayToDB(data: responseData["data"] as! NSArray)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
