//
//  DetailedViewController.swift
//  BusSchedule
//
//  Created by admin on 3/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import CoreData


class DetailedViewController: UIViewController {

    var id: String! = ""
    
    @IBOutlet weak var fromCity: UILabel!
    @IBOutlet weak var toCity: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var fromInfo: UILabel!
    @IBOutlet weak var toInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Detailed activity recieve object with id: \(id)")
        setUpData()
    }
    
    func setUpData() {
        setUpView(item: CoreDataManager.getInstance().getScheduleItemById(id: id)!)
    }
    
    func setUpView(item: ScheduleItem) {
        fromCity.text = item.from_city?.name
        toCity.text = item.to_city?.name
        fromDate.text = DateHelper.convertDateToString(date: item.from_date as! Date)
        toDate.text = DateHelper.convertDateToString(date: item.to_date as! Date)
        info.text = item.info
        price.text = String(describing: item.price)
        fromTime.text = item.from_time
        toTime.text = item.to_time
        fromInfo.text = item.from_info
        toInfo.text = item.to_info
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
