
class DetailedViewController: UIViewController {

    //var scheduleItem: ScheduleItem? = nil
    var scheduleItem: ScheduleItemRealm? = nil
    var model: UniversalDbModel? = nil
    
    
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
        setUpWithModel(model: model!)
        
    }
    
    func setUpWithModel(model: UniversalDbModel) {
        fromCity.text = model.getFromCityName()
        toCity.text = model.getToCityName()
        fromDate.text = DateConverter.convertDateToString(date: model.getFromDate())
        toDate.text = DateConverter.convertDateToString(date: model.getToDate())
        info.text = model.getInfo()
        price.text = String(describing: model.getPrice())
        fromInfo.text = model.getFromInfo()
        toInfo.text = model.getToInfo()
    }
    

}
