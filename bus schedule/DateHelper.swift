//
//  DateHelper.swift
//  BusSchedule
//
//  Created by admin on 3/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation


class DateHelper {
    
    
    static let dateFormatterGet = DateFormatter()
    
    static let dateFormatter = DateFormatter()
    
    static func convertStringToDate(string: String) -> Date{
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        return dateFormatterGet.date(from: string)!
    }

    static func convertDateToString(date: Date) -> String {
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func convertDateToStringForResponse(date: Date) -> String {
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }
    
}
