//
//  NetworkManager.swift
//  bus schedule
//
//  Created by kreatimont on 01/04/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static var networkManager: NetworkManager? = nil
    
    static func getInstance() -> NetworkManager {
        if(networkManager == nil) {
            networkManager = NetworkManager()
        }
        return networkManager!
    }
    
    public func loadData(array: [ScheduleItem]) {
        
    }
    
}
