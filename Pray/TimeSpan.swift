//
//  TimeSpan.swift
//  Pray
//
//  Created by Sumner Evans on 3/27/16.
//  Copyright © 2016 SummationTech. All rights reserved.
//

import Foundation

public class TimeSpan: Comparable {
    var Years: Int
    var Months: Int
    var Days: Int
    var Hours: Int
    var Minutes: Int
    var Seconds: Int
    
    init(years: Int, months: Int, days: Int, hours: Int, minutes: Int, seconds: Int) {
        self.Years = years
        self.Months = months
        self.Days = days
        self.Hours = hours
        self.Minutes = minutes
        self.Seconds = seconds
    }
    
    convenience init(hours: Int, minutes: Int, seconds: Int) {
        self.init(years: 0, months: 0, days: 0, hours: hours, minutes: minutes, seconds: seconds)
    }
    
    func ToDateTime() -> DateTime {
        return DateTime(year: self.Years, month: self.Months, day: self.Days, hour: self.Hours, minute: self.Minutes, second: self.Seconds)
    }
}

// MARK: DateTime Comparisons

public func ==(lhs: TimeSpan, rhs: TimeSpan) -> Bool {
    return lhs.ToDateTime() == rhs.ToDateTime()
}

public func <(lhs: TimeSpan, rhs: TimeSpan) -> Bool {
    return lhs.ToDateTime() < rhs.ToDateTime()
}