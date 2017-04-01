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

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var enteredFromDate: UITextField!
    @IBOutlet weak var enteredToDate: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataArray: [ScheduleItem] = []
    let cellId = "scheduleCell"

    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for mergin data in core data
        self.context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        //implement tableView
        tableView.delegate = self
        tableView.dataSource = self
        
    
        retrieveDataFromDb()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableData(_:)), name: .reload, object: nil)
        
         //FIXME: refresh control
        
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Loading..")
//        refreshControl.addTarget(self, action: Selector(("refresh:")), for: UIControlEvents.valueChanged)
//        tableView.addSubview(refreshControl)
        
    }
    
    func refresh(sender:AnyObject) {
        refreshBegin(newtext: "Refresh",
                     refreshEnd: {(x:Int) -> () in
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(newtext: String, refreshEnd:(Int) -> ()) {
        DispatchQueue.global(qos: .background).async {
            
        }
    }
    
    func updateViews() {
        //update info in table view cells and period labels
        tableView.reloadData()
        if(dataArray.count > 0) {
            enteredFromDate.text = DateHelper.convertDateToString(date: dataArray.first?.from_date as! Date)
            enteredToDate.text = DateHelper.convertDateToString(date: dataArray.last?.to_date as! Date)
        } else {
            enteredFromDate.text = ""
            enteredToDate.text = ""
        }
    }
    
    func reloadTableData(_ notification: Notification) {
        retrieveDataFromDb()
    }
    
    @IBAction func clearCoreData(_ sender: Any) {
        clearDb()
    }
    
    //MARK: Core Data
    
    func clearDb() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleItem")
        
        let result = try? context.fetch(fetchRequest)
        
        for object in result! {
            context.delete(object as! NSManagedObject)
        }
        
        print("Deleted items(schedule item): \(result?.count)")
        
        
        let fetchRequestCity = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        
        let resultCity = try? context.fetch(fetchRequestCity)
        
        for object in resultCity! {
            context.delete(object as! NSManagedObject)
        }
        
        do {
            try context.save()
        } catch {
            
        }
        
        print("Deleted items(city): \(resultCity?.count)")
        
        retrieveDataFromDb()
    }
    
    func retrieveDataFromDb() {
        do {
            let fetch:NSFetchRequest = ScheduleItem.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "from_date", ascending: true)
            fetch.sortDescriptors = [sortDescriptor]
            dataArray.removeAll()
            dataArray = try context.fetch(fetch)
            
            print("Data retrieved from DB, dataArray.count = \(dataArray.count)")
        } catch let error as NSError {
            print("Data was not retrieved, occured by \(error)")
        }
        updateViews()
    }
    
    // MARK: Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSection: Int = 0
        
        if dataArray.count == 0 {
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























