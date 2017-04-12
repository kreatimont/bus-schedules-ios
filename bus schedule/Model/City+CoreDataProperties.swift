//
//  City+CoreDataProperties.swift
//  bus schedule
//
//  Created by Alexandr Nadtoka on 4/12/17.
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
    @NSManaged public var scheduleFrom: NSSet?
    @NSManaged public var scheduleTo: NSSet?

}

// MARK: Generated accessors for scheduleFrom
extension City {

    @objc(addScheduleFromObject:)
    @NSManaged public func addToScheduleFrom(_ value: ScheduleItem)

    @objc(removeScheduleFromObject:)
    @NSManaged public func removeFromScheduleFrom(_ value: ScheduleItem)

    @objc(addScheduleFrom:)
    @NSManaged public func addToScheduleFrom(_ values: NSSet)

    @objc(removeScheduleFrom:)
    @NSManaged public func removeFromScheduleFrom(_ values: NSSet)

}

// MARK: Generated accessors for scheduleTo
extension City {

    @objc(addScheduleToObject:)
    @NSManaged public func addToScheduleTo(_ value: ScheduleItem)

    @objc(removeScheduleToObject:)
    @NSManaged public func removeFromScheduleTo(_ value: ScheduleItem)

    @objc(addScheduleTo:)
    @NSManaged public func addToScheduleTo(_ values: NSSet)

    @objc(removeScheduleTo:)
    @NSManaged public func removeFromScheduleTo(_ values: NSSet)

}
