
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
        } else {
            showEmptyStub()
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
    
    func showEmptyStub() {
        
        self.fromCity.isHidden = true
        self.toCity.isHidden = true
        self.fromDate.isHidden = true
        self.toDate.isHidden = true
        self.info.isHidden = true
        self.fromInfo.isHidden = true
        self.toInfo.isHidden = true
        self.price.isHidden = true
        self.fromTime.isHidden = true
        self.toTime.isHidden = true
        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        noDataLabel.text = "empty_stub".localized
        noDataLabel.textColor = UIColor.black
        noDataLabel.textAlignment = .center
        self.view.addSubview(noDataLabel)
    }
    

}
