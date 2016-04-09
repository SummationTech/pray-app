//
//  TimeSpan.swift
//  Pray
//
//  Created by Sumner Evans on 3/27/16.
//  Copyright © 2016 SummationTech. All rights reserved.
//

import Foundation

public class TimeSpan: NSCoder, Comparable {
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
        self.Years = aDecoder.decodeIntegerForKey(PropertyKey.Years)
        self.Months = aDecoder.decodeIntegerForKey(PropertyKey.Months)
        self.Days = aDecoder.decodeIntegerForKey(PropertyKey.Days)
        self.Hours = aDecoder.decodeIntegerForKey(PropertyKey.Hours)
        self.Minutes = aDecoder.decodeIntegerForKey(PropertyKey.Minutes)
        self.Seconds = aDecoder.decodeIntegerForKey(PropertyKey.Seconds)
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeInteger(self.Years, forKey: PropertyKey.Years)
        aCoder.encodeInteger(self.Months, forKey: PropertyKey.Months)
        aCoder.encodeInteger(self.Days, forKey: PropertyKey.Days)
        aCoder.encodeInteger(self.Hours, forKey: PropertyKey.Hours)
        aCoder.encodeInteger(self.Minutes, forKey: PropertyKey.Minutes)
        aCoder.encodeInteger(self.Seconds, forKey: PropertyKey.Seconds)
    }
}


// MARK: DateTime Comparisons

public func ==(lhs: TimeSpan, rhs: TimeSpan) -> Bool {
    return lhs.ToDateTime() == rhs.ToDateTime()
}

public func <(lhs: TimeSpan, rhs: TimeSpan) -> Bool {
    return lhs.ToDateTime() < rhs.ToDateTime()
}