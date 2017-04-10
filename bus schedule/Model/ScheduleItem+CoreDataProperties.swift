//
//  ScheduleItem+CoreDataProperties.swift
//  bus schedule
//
//  Created by Alexandr Nadtoka on 4/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import CoreData


extension ScheduleItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleItem> {
        return NSFetchRequest<ScheduleItem>(entityName: "ScheduleItem");
    }

    @NSManaged public var fromDate: NSDate?
    @NSManaged public var fromInfo: String?
    @NSManaged public var id: String?
    @NSManaged public var info: String?
    @NSManaged public var price: Int16
    @NSManaged public var toDate: NSDate?
    @NSManaged public var toInfo: String?
    @NSManaged public var fromCity: City?
    @NSManaged public var toCity: City?

}
