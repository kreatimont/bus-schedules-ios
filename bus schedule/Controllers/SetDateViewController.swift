//  SetDateViewController.swift
//  BusSchedule
//
//  Created by admin on 3/29/17.
//  Copyright © 2017 admin. All rights reserved.

import AFNetworking

class SetDateViewController: UIViewController, ApiListener {
    
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var loadedData: [ScheduleItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoaderStub(state: false)
        initActivityIndicator()
    }
    
    func initActivityIndicator() {
        activityIndicator.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        activityIndicator.backgroundColor = UIColor.darkGray
        activityIndicator.layer.cornerRadius = 6.0
        activityIndicator.frame = .init(x: self.view.bounds.size.width/2 - 40, y: self.view.bounds.size.height/2 - 40, width: 80.0, height: 80.0)
    }
    
    @IBAction func setDate(_ sender: Any) {
        isLoaderStub(state: true)
        //let url: String = baseURL + modeFromDate + DateHelper.convertDateToStringForResponse(date: fromDatePicker.date) + modeToDate + DateHelper.convertDateToStringForResponse(date: toDatePicker.date)
        ApiManager.instance.loadData(listener: self, url: ApiManager.instance.createUrl(dateFrom: fromDatePicker.date, dateTo: toDatePicker.date))
    }
    
    func isLoaderStub(state: Bool) {
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
            
            //self.navigationItem.hidesBackButton = false
            self.view.isUserInteractionEnabled = true
            self.btnSend.isEnabled = true
            self.fromDatePicker.isEnabled = true
            self.toDatePicker.isEnabled = true
        }
    }
    
    //MARK: api listener implementation 
    
    internal func success() {
        isLoaderStub(state: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    internal func parseError() {
        isLoaderStub(state: false)
        let alert = UIAlertController(title: "Error", message: "Response isn`t success", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func connectionError(error: NSError, url: String) {
        isLoaderStub(state: false)
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: { action in
            ApiManager.instance.loadData(listener: self, url: url)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}















