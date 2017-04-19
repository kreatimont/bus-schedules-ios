
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
