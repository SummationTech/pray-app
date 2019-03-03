//
//  TimeSpan.swift
//  Pray
//
//  Created by Sumner Evans on 3/27/16.
//  Copyright © 2016 SummationTech. All rights reserved.
//

import Foundation

open class TimeSpan: NSCoder, Comparable {
    var Years: Int!
    var Months: Int!
    var Days: Int!
    var Hours: Int!
    var Minutes: Int!
    var Seconds: Int!
    
    struct PropertyKey {
        static let Years = "years"
        static let Months = "months"
        static let Days = "days"
        static let Hours = "hours"
        static let Minutes = "minutes"
        static let Seconds = "seconds"
    }
    
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
    
    // MARK: NSCoder Members
    required public init(coder aDecoder: NSCoder!) {
        self.Years = aDecoder.decodeInteger(forKey: PropertyKey.Years)
        self.Months = aDecoder.decodeInteger(forKey: PropertyKey.Months)
        self.Days = aDecoder.decodeInteger(forKey: PropertyKey.Days)
        self.Hours = aDecoder.decodeInteger(forKey: PropertyKey.Hours)
        self.Minutes = aDecoder.decodeInteger(forKey: PropertyKey.Minutes)
        self.Seconds = aDecoder.decodeInteger(forKey: PropertyKey.Seconds)
    }
    
    func encodeWithCoder(_ aCoder: NSCoder!) {
        aCoder.encode(self.Years, forKey: PropertyKey.Years)
        aCoder.encode(self.Months, forKey: PropertyKey.Months)
        aCoder.encode(self.Days, forKey: PropertyKey.Days)
        aCoder.encode(self.Hours, forKey: PropertyKey.Hours)
        aCoder.encode(self.Minutes, forKey: PropertyKey.Minutes)
        aCoder.encode(self.Seconds, forKey: PropertyKey.Seconds)
    }
}


// MARK: DateTime Comparisons

public func ==(lhs: TimeSpan, rhs: TimeSpan) -> Bool {
    return lhs.ToDateTime() == rhs.ToDateTime()
}

public func <(lhs: TimeSpan, rhs: TimeSpan) -> Bool {
    return lhs.ToDateTime() < rhs.ToDateTime()
}
