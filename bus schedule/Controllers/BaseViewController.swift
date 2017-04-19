
class BaseViewController: UIViewController {
    
    func displayConnectionErrorAlert(error: Error) {
        let alert = UIAlertController(title: "error_title".localized, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "cancel_btn".localized, style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayResponseErrorAlert() {
        let alert = UIAlertController(title: "error".localized, message: "response_failed".localized, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "cancel_btn".localized, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
