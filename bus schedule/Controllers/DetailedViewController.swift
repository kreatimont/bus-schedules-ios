
class DetailedViewController: UIViewController {

    var model: AbstractScheduleItem? = nil
        
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
        if(model != nil) {
            setUpWithModel(model: model!)
        }
    }
    
    func setUpWithModel(model: AbstractScheduleItem) {
        fromCity.text = model.getFromCity().getName()
        toCity.text = model.getToCity().getName()
        fromDate.text = DateConverter.convertDateToString(date: model.getFromDate())
        toDate.text = DateConverter.convertDateToString(date: model.getToDate())
        info.text = model.getInfo()
        price.text = String(describing: model.getPrice())
        fromInfo.text = model.getFromInfo()
        toInfo.text = model.getToInfo()
    }
    
}
