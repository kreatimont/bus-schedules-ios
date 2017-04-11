//
//  ScheduleItem+CoreDataClass.swift
//  bus schedule
//
//  Created by Alexandr Nadtoka on 4/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import CoreData


public class ScheduleItem: NSManagedObject, AbstractScheduleItem {
    
    internal func getId() -> Int {
        return Int(self.id!)!
    }
    
    internal func getBusId() -> Int {
        return Int(self.busId)
    }
    
    internal func getPrice() -> Int {
        return Int(self.price)
    }
    
    internal func getReservationCount() -> Int {
        return Int(self.reservationCount)
    }
    
    internal func getInfo() -> String {
        return self.info!
    }
    
    internal func getFromInfo() -> String {
        return self.fromInfo!
    }
    
    internal func getToInfo() -> String {
        return self.toInfo!
    }
    
    internal func getFromDate() -> Date {
        return self.fromDate as! Date
    }
    
    internal func getToDate() -> Date {
        return self.toDate as! Date
    }
    
    internal func getFromCity() -> AbstractScheduleCity {
        return self.fromCity!
    }
    
    internal func getToCity() -> AbstractScheduleCity {
        return self.toCity!
    }
    
}
