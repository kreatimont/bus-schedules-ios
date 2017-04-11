//
//  City+CoreDataProperties.swift
//  bus schedule
//
//  Created by Alexandr Nadtoka on 4/11/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City");
    }

    @NSManaged public var highlight: Int16
    @NSManaged public var name: String?
    @NSManaged public var schedule_from: NSSet?
    @NSManaged public var schedule_to: NSSet?

}

// MARK: Generated accessors for schedule_from
extension City {

    @objc(addSchedule_fromObject:)
    @NSManaged public func addToSchedule_from(_ value: ScheduleItem)

    @objc(removeSchedule_fromObject:)
    @NSManaged public func removeFromSchedule_from(_ value: ScheduleItem)

    @objc(addSchedule_from:)
    @NSManaged public func addToSchedule_from(_ values: NSSet)

    @objc(removeSchedule_from:)
    @NSManaged public func removeFromSchedule_from(_ values: NSSet)

}

// MARK: Generated accessors for schedule_to
extension City {

    @objc(addSchedule_toObject:)
    @NSManaged public func addToSchedule_to(_ value: ScheduleItem)

    @objc(removeSchedule_toObject:)
    @NSManaged public func removeFromSchedule_to(_ value: ScheduleItem)

    @objc(addSchedule_to:)
    @NSManaged public func addToSchedule_to(_ values: NSSet)

    @objc(removeSchedule_to:)
    @NSManaged public func removeFromSchedule_to(_ values: NSSet)

}
