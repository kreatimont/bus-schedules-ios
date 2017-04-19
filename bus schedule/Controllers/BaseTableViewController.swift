
class BaseTableViewController: UITableViewController {
    
    var numOfSection = 0
    
    func setEmptyStub() {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text = "empty_stub".localized
        noDataLabel.textColor = UIColor.black
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 3
        noDataLabel.lineBreakMode = .byWordWrapping
        tableView.backgroundView = noDataLabel
        tableView.separatorStyle = .none
        numOfSection = 0
    }
    
    func removeEmptyStub() {
        tableView.separatorStyle = .singleLine
        numOfSection = 1
    }
    
}
