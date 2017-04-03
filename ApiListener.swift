protocol ApiListener {
    func success()
    func connectionError(error: NSError, url: String)
    func parseError()
}
