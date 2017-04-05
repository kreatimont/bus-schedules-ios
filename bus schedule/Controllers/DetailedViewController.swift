
class DetailedViewController: UIViewController {

    var scheduleItem: ScheduleItem? = nil
    
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
        setUpWithScheduleItem(item: scheduleItem!)
    }
    
    func setUpWithScheduleItem(item: ScheduleItem) {
        fromCity.text = item.from_city?.name
        toCity.text = item.to_city?.name
        fromDate.text = DateConverter.convertDateToString(date: item.from_date as! Date)
        toDate.text = DateConverter.convertDateToString(date: item.to_date as! Date)
        info.text = item.info
        price.text = String(describing: item.price)
        fromTime.text = item.from_time
        toTime.text = item.to_time
        fromInfo.text = item.from_info
        toInfo.text = item.to_info
    }

}
