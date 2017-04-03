class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ApiListener {
    
    @IBOutlet weak var labelTo: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateFrom: UILabel!
    @IBOutlet weak var dateTo: UILabel!
    
    @IBOutlet weak var btnSet: UIButton!

    var dataArray: [ScheduleItem] = []
    
    let cellId = "scheduleCell"

    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        dataArray = CoreDataManager.getInstance().retrieveDataFromDb()
        self.updateViews()
        initTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableData(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }

    func reloadTableData(_ notification: Notification) {
        dataArray = CoreDataManager.getInstance().retrieveDataFromDb()
        self.updateViews()
    }
    
    @IBAction func clearCoreData(_ sender: Any) {
        CoreDataManager.getInstance().clearDb()
        dataArray.removeAll()
        self.updateViews()
    }
    
    func updateViews() {
        //update info in table view cells and labels
        tableView.reloadData()
        if(dataArray.count > 0) {
            tableView.addSubview(self.refreshControl)
            refreshControl.isEnabled = true
            dateFrom.text = DateHelper.convertDateToString(date: dataArray.first?.from_date as! Date)
            dateTo.text = DateHelper.convertDateToString(date: dataArray.last?.to_date as! Date)
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
            ApiManager.instance.loadData(listener: self, url: ApiManager.instance.createUrl(dateFrom: self.dataArray.first?.from_date as! Date, dateTo: self.dataArray.last?.from_date as! Date))
        }
    }
    
    //MARK: Api listener implements 
    
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
            detailedVC.scheduleItem = dataArray[selectedRow]
        }
    }

}























