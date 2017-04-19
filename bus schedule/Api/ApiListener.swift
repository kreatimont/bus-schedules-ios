
protocol ApiListener {
    
    func responseSuccessed()
    func responseFailed()
    func connectionError(error: Error)
    
}
