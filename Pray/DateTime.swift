//
//  DateTime.swift
//
//  Created by Sumner Evans on 3/27/16.
//  Copyright © 2016 SummationTech. All rights reserved.
//
// CREDITS:
//
// Thanks to Ronny Kibet for to string and date-from-string technique
// http://ronnykibet.com/convert-nsdate-to-string-and-vice-versa-swift/

import Foundation

/// DateTime is a class for dealing with dates.
///
/// DateTime is based off of the [C#.NET DateTime class](https://msdn.microsoft.com/en-us/library/system.datetime(v=vs.110).aspx) and includes useful initializers, setters, getters, and much more.

public struct DateTime: Comparable {
    // MARK: Underlying NSDate
    private var underlyingNSDate: NSDate! = NSDate()
    
    private var underlyingDateComponents: NSDateComponents {
        get {
            // http://roadfiresoftware.com/2015/08/how-to-get-components-from-a-date-in-swift/
            let unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second]
            return NSCalendar.currentCalendar().components(unitFlags, fromDate: self.underlyingNSDate)
        }
        set {
            self.underlyingNSDate = NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(newValue)
        }
    }
    
    // MARK: Date Components
    private mutating func setComponent(newValue: AnyObject?, componentKey: String) {
        let dateCmps = self.underlyingDateComponents;
        dateCmps.setValue(newValue, forKey: componentKey)
        self.underlyingDateComponents = dateCmps
    }
    
    public var Year: Int {
        get { return self.underlyingDateComponents.year }
        set { self.setComponent(newValue, componentKey: "Year") }
    }
    
    public var Month: Int {
        get { return self.underlyingDateComponents.month }
        set { self.setComponent(newValue, componentKey: "Month") }
    }
    
    public var Day: Int {
        get { return self.underlyingDateComponents.day }
        set { self.setComponent(newValue, componentKey: "Day") }
    }
    
    public var Hour: Int {
        get { return self.underlyingDateComponents.hour }
        set { self.setComponent(newValue, componentKey: "Hour") }
    }
    
    public var Minute: Int {
        get { return self.underlyingDateComponents.minute }
        set { self.setComponent(newValue, componentKey: "Minute") }
    }
    
    public var Second: Int {
        get { return self.underlyingDateComponents.second }
        set { self.setComponent(newValue, componentKey: "Second") }
    }
    
    public var TimeZone: NSTimeZone {
        get { return self.underlyingDateComponents.timeZone! }
        set { self.setComponent(newValue, componentKey: "TimeZone") }
    }
    
    public static var Now: DateTime {
        get {
            return DateTime()
        }
    }
    
    // MARK: Initialization
    init() {
        self.underlyingNSDate = NSDate()
    }
    
    init(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, timeZone: NSTimeZone = NSTimeZone.systemTimeZone()) {
        self.Year = year
        self.Month = month
        self.Day = day
        self.Hour = hour
        self.Minute = minute
        self.Second = second
        self.TimeZone = timeZone
    }
    
    init(hour: Int, minute: Int = 0, second: Int = 0) {
        let now = DateTime.Now
        self.init(year: now.Year, month: now.Month, day: now.Day, hour: hour, minute: minute, second: second)
    }
    
    init(ticks: Double) {
        self.underlyingNSDate = NSDate(timeIntervalSince1970: ticks)
    }
    
    init(dateString: String, dateFormat: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        self.underlyingNSDate = dateFormatter.dateFromString(dateString)
    }
    
    init(nsDate: NSDate?) {
        if (nsDate == nil) {
            self.underlyingNSDate = NSDate()
        } else {
            self.underlyingNSDate = nsDate
        }
    }
    
    // MARK: Properties
    public var TimeOfDay: TimeSpan {
        return TimeSpan(hours: self.Hour, minutes: self.Minute, seconds: self.Second)
    }
    
    // MARK: Helper Functions
    func ToNSDate() -> NSDate {
        return self.underlyingNSDate
    }
    
    func Within(date1: DateTime, date2: DateTime) -> Bool {
        return (date1 > self && self > date2) || (date2 > self && self > date1)
    }
    
    mutating func Add(seconds: Int) {
        self.underlyingNSDate = self.underlyingNSDate.dateByAddingTimeInterval(Double(seconds))
    }
    
    mutating func AddMinutes(minutes: Int) {
        self.Add(minutes * 60)
    }
    
    public func ToString(dateFormat: String = "yyyy/MM/dd HH:mm:ss") -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.stringFromDate(self.underlyingNSDate)
    }
}

// MARK: NSDate Comparisons
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

// MARK: DateTime Comparisons

public func ==(lhs: DateTime, rhs: DateTime) -> Bool {
    return lhs.ToNSDate() == rhs.ToNSDate()
}

public func <(lhs: DateTime, rhs: DateTime) -> Bool {
    return lhs.ToNSDate() < rhs.ToNSDate()
}