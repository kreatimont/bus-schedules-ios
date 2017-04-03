//
//  ViewController.swift
//  BusSchedule
//
//  Created by admin on 3/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import AFNetworking
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelTo: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateFrom: UILabel!
    @IBOutlet weak var dateTo: UILabel!
    
    @IBOutlet weak var btnSet: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataArray: [ScheduleItem] = []
    let cellId = "scheduleCell"

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for merging data in core data
        self.context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        //implement tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        dataArray = CoreDataManager.getInstance().retrieveDataFromDb()
        self.updateViews()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadTableData(_:)),
                                               name: NSNotification.Name(rawValue: "reload"),
                                               object: nil)
        
        
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        DispatchQueue.global(qos: .background).async {
            self.dataArray.sort { (itemOne, itemTwo) -> Bool in
                return ((itemOne.from_date?.compare(itemTwo.from_date as! Date))?.rawValue)! > 0
            }
            sleep(3)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
       
    }
    
    func updateViews() {
        //update info in table view cells and period labels
        tableView.reloadData()
        if(dataArray.count > 0) {
            dateFrom.text = DateHelper.convertDateToString(date: dataArray.first?.from_date as! Date)
            dateTo.text = DateHelper.convertDateToString(date: dataArray.last?.to_date as! Date)
            labelFrom.isHidden = false
            labelTo.isHidden = false
        } else {
            dateFrom.text = ""
            dateTo.text = ""
            labelFrom.isHidden = true
            labelTo.isHidden = true
            
        }
    }
    
    //MARK: Core Data
    
    func reloadTableData(_ notification: Notification) {
        dataArray = CoreDataManager.getInstance().retrieveDataFromDb()
        self.updateViews()
    }
    
    @IBAction func clearCoreData(_ sender: Any) {
        CoreDataManager.getInstance().clearDb()
        dataArray.removeAll()
        self.updateViews()
    }
    
    
    // MARK: Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSection: Int = 0
        
        if dataArray.count == 0 {
            //MARK: empty stub
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No data available"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
            numOfSection = 1
            tableView.backgroundView = nil
        }
        return numOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ScheduleCell
        
        //customize cell
        cell.layer.cornerRadius = 4.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        let scheduleItem = dataArray[indexPath.row]
        
        cell.info.text = (scheduleItem.from_city?.name)! + " -> " + (scheduleItem.to_city?.name)!
        cell.fromDate.text = DateHelper.convertDateToString(date: scheduleItem.from_date as! Date)
        cell.toDate.text = DateHelper.convertDateToString(date: scheduleItem.to_date as! Date)
        cell.price.text = String(scheduleItem.price)
        
        return cell
    }
    
    // MARK: TableView Cell click
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detSeq") {
            let detailedVC = segue.destination as! DetailedViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            detailedVC.id = dataArray[selectedRow].id!
        }
    }

}























