
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ApiListener {
    
    @IBOutlet weak var labelTo: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateFrom: UILabel!
    @IBOutlet weak var dateTo: UILabel!
    
    @IBOutlet weak var btnSet: UIButton!

    var dataArray: [AbstractScheduleItem] = []
    
    let cellId = "scheduleCell"

    let refreshControl = UIRefreshControl()
    
    var dbManager: AbstractDbManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //set onClickListener
        let labelTabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLabelClick(tapGestureRecognizer:)))
        labelTo.addGestureRecognizer(labelTabGestureRecognizer)
        labelTo.isUserInteractionEnabled = true
        
        //set current db manager
        dbManager = RealmDbManager.instance
        
        dataArray = (dbManager?.retrieveDataFromDb())!
        self.updateViews()
        initTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableData(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }

    func onLabelClick(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let tappedLabel = tapGestureRecognizer.view as! UILabel
        
        let alert = UIAlertController(title: "Label", message: "Label clicked\(tappedLabel.text)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

        
    }
    
    func reloadTableData(_ notification: Notification) {
        dataArray = (dbManager?.retrieveDataFromDb())!
        self.updateViews()
    }
    
    @IBAction func clearCoreData(_ sender: Any) {
        dbManager?.clearDb()
        dataArray.removeAll()
        self.updateViews()
    }
    
    func updateViews() {
        tableView.reloadData()
        if(dataArray.count > 0) {
            tableView.addSubview(self.refreshControl)
            refreshControl.isEnabled = true
            
            dateFrom.text = DateConverter.convertDateToString(date: (dataArray.first?.getFromDate())!)
            dateTo.text = DateConverter.convertDateToString(date: (dataArray.last?.getToDate())!)
            
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
            
            DispatchQueue.main.async {
                ApiManager.instance.loadData(listener: self, url: ApiManager.instance.createUrl(
                    dateFrom: self.dataArray.first!.getFromDate(), dateTo: self.dataArray.last!.getToDate()), dbManager: self.dbManager!)

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
           (self.childViewControllers as! [DetailedViewController])[0].setUpWithModel(model: dataArray[indexPath.row])
        }
    }
    
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
        
        cell.info.text = (scheduleItem.getFromCity().getName()) + " -> " + (scheduleItem.getToCity().getName())
        cell.fromDate.text = DateConverter.convertDateToString(date: scheduleItem.getFromDate())
        cell.toDate.text = DateConverter.convertDateToString(date: scheduleItem.getToDate())
        
        cell.price.text = String(scheduleItem.getPrice())
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detSeq") {
            let detailedVC = segue.destination as! DetailedViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            detailedVC.model = dataArray[selectedRow]
            
        }
        if(segue.identifier == "setDate") {
            let setDateVC = segue.destination as! SetDateViewController
            setDateVC.dbManager = dbManager
        }
    }

}






















