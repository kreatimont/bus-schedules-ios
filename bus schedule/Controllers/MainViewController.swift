
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension UIColor{
    
    static var indigo: UIColor {
        return UIColor(red:0.66, green:0.76, blue:1.00, alpha:1.0)
    }
    
    class func getCustomBlueColor() -> UIColor{
        return UIColor(red:0.86, green:0.73, blue:1.00, alpha:1.0)
    }
    
    class func getCustomGreenColor() -> UIColor{
        return UIColor(red: 0.80, green:0.95, blue:0.90 ,alpha:1.0)
    }
}

class ViewController:  BaseTableViewController, UITableViewDelegate, UITableViewDataSource, ApiListener {
    
    @IBOutlet weak var labelTo: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateFrom: UILabel!
    @IBOutlet weak var dateTo: UILabel!
    @IBOutlet weak var btnSet: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var dataArray: [AbstractScheduleItem] = []
    
    let refreshControl = UIRefreshControl()
    
    var dbManager: AbstractDbManager? = nil


    override func viewDidLoad() {
        super.viewDidLoad()

        //setUp container view
        if(containerView != nil) {
            containerView.isHidden = true
            containerView.layer.cornerRadius = 6.0
            containerView.layer.borderWidth = 1.0
            containerView.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        let panGesutureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onLabelDragged(recognizer:)))
        
        let tabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLabelClick(recognizer:)))

        
        //set onClickListener (Tab gesture)
        labelTo.addGestureRecognizer(tabGestureRecognizer)
        labelTo.isUserInteractionEnabled = true
        
        //set dragListener (Pan gesture)
        btnSet.addGestureRecognizer(panGesutureRecognizer)
        btnSet.isUserInteractionEnabled = true
        
        //set current db manager
        dbManager = RealmDbManager.instance
        
        dataArray = (dbManager?.retrieveDataFromDb())!
        self.updateViews()
        initTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableData(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    func onLabelDragged(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }

    func onLabelClick(recognizer: UITapGestureRecognizer) {
        let tappedLabel = recognizer.view as! UILabel
        
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
                ApiManager.instance.loadScheduleItems(dateFrom: self.dataArray.first!.getFromDate(), dateTo: self.dataArray.last!.getToDate(), listener: self, dbManager: self.dbManager!, vc: self)
            }
        }
    }
    
    //MARK: Api listener implementation
    
    internal func responseSuccessed() {
        self.updateViews()
        self.refreshControl.endRefreshing()
    }
    
    internal func responseFailed() {
        self.refreshControl.endRefreshing()
    }
    
    internal func connectionError(error: Error) {
        self.refreshControl.endRefreshing()
    }
    
    // MARK: Table view data source & delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            dbManager?.deleteItemById(id: String(dataArray[indexPath.row].getId()))
            dataArray.remove(at: indexPath.row)
            self.updateViews()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
           (self.childViewControllers as! [DetailedViewController])[0].setUpWithModel(model: dataArray[indexPath.row])
            containerView.isHidden = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSection: Int = 0
        
        if dataArray.count == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "empty_stub".localized
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 3
            noDataLabel.lineBreakMode = .byWordWrapping
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.id) as! ScheduleCell
        
        //customize cell
        cell.layer.cornerRadius = 4.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        if(indexPath.row % 2 == 0) {
            cell.contentView.backgroundColor = UIColor.indigo
        } else {
            cell.contentView.backgroundColor = UIColor.getCustomGreenColor()
        }
        
        let scheduleItem = dataArray[indexPath.row]
        
        cell.info.text = (scheduleItem.getFromCity().getName()) + " -> " + (scheduleItem.getToCity().getName())
        cell.fromDate.text = DateConverter.convertDateToString(date: scheduleItem.getFromDate())
        cell.toDate.text = DateConverter.convertDateToString(date: scheduleItem.getToDate())
        
        cell.price.text = String(scheduleItem.getPrice())
        
        return cell
    }
    
    //MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detaildeSegue") {
            let detailedVC = segue.destination as! DetailedViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            detailedVC.model = dataArray[selectedRow]
            
        }
        if(segue.identifier == "setDateSegue") {
            let setDateVC = segue.destination as! SetDateViewController
            setDateVC.dbManager = dbManager
        }
    }

}






















