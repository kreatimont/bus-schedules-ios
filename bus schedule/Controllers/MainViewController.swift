
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ApiListener {
    
    @IBOutlet weak var labelTo: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateFrom: UILabel!
    @IBOutlet weak var dateTo: UILabel!
    
    @IBOutlet weak var btnSet: UIButton!

    //var dataArray: [ScheduleItem] = []
    var dataArray: [ScheduleItemRealm] = []
    
    let cellId = "scheduleCell"

    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //dataArray = CoreDataManager.instance.retrieveDataFromDb()
        dataArray = RealmManager.instance.retrieveDataFromDb()
        self.updateViews()
        initTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableData(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }

    func reloadTableData(_ notification: Notification) {
        //dataArray = CoreDataManager.instance.retrieveDataFromDb()
        dataArray = RealmManager.instance.retrieveDataFromDb()
        self.updateViews()
    }
    
    @IBAction func clearCoreData(_ sender: Any) {
        CoreDataManager.instance.clearDb()
        dataArray.removeAll()
        self.updateViews()
    }
    
    func updateViews() {
        tableView.reloadData()
        if(dataArray.count > 0) {
            tableView.addSubview(self.refreshControl)
            refreshControl.isEnabled = true
            
//            dateFrom.text = DateConverter.convertDateToString(date: dataArray.first?.from_date as! Date)
//            dateTo.text = DateConverter.convertDateToString(date: dataArray.last?.to_date as! Date)
            
            dateFrom.text = DateConverter.convertDateToString(date: (dataArray.first?.fromDate)!)
            dateTo.text = DateConverter.convertDateToString(date: (dataArray.last?.toDate)!)
            
            labelFrom.isHidden = false
            labelTo.isHidden = false
        } else {
            self.refreshControl.removeFromSuperview()
            refreshControl.isEnabled = false
            dateFrom.text = ""
            dateTo.text = ""
            labelFrom.isHidden = true
            labelTo.isHidden = true
        }
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh), for: UIControlEvents.valueChanged)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .background).async {
//            ApiManager.instance.loadData(listener: self, url: ApiManager.instance.createUrl(dateFrom: self.dataArray.first?.from_date as! Date, dateTo: self.dataArray.last?.from_date as! Date))
            
            DispatchQueue.main.async {
                ApiManager.instance.loadData(listener: self,
                                             url: ApiManager.instance.createUrl(
                                                dateFrom: self.dataArray.first!.fromDate, dateTo: self.dataArray.last!.fromDate))

            }
            
        }
    }
    
    //MARK: Api listener implementation
    
    internal func success() {
        self.updateViews()
        self.refreshControl.endRefreshing()
    }
    
    internal func parseError() {
        self.refreshControl.endRefreshing()
    }
    
    internal func connectionError(error: NSError, url: String) {
        self.refreshControl.endRefreshing()
    }
    
    // MARK: Table view data source & delegate
    
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
        
//        cell.info.text = (scheduleItem.from_city?.name)! + " -> " + (scheduleItem.to_city?.name)!
//        cell.fromDate.text = DateConverter.convertDateToString(date: scheduleItem.from_date as! Date)
//        cell.toDate.text = DateConverter.convertDateToString(date: scheduleItem.to_date as! Date)
        
        cell.info.text = (scheduleItem.fromCity?.name)! + " -> " + (scheduleItem.toCity?.name)!
        cell.fromDate.text = DateConverter.convertDateToString(date: scheduleItem.fromDate)
        cell.toDate.text = DateConverter.convertDateToString(date: scheduleItem.toDate)
        
        cell.price.text = String(scheduleItem.price)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detSeq") {
            let detailedVC = segue.destination as! DetailedViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            detailedVC.scheduleItem = dataArray[selectedRow]
        }
    }

}






















