
protocol ApiListener {
    
    func success()
    func connectionError(error: NSError)
    func parseError()
    
}
