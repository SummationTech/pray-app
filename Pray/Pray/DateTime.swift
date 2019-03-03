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
    fileprivate var underlyingNSDate: Date! = Date()
    
    fileprivate var underlyingDateComponents: DateComponents {
        get {
            // http://roadfiresoftware.com/2015/08/how-to-get-components-from-a-date-in-swift/
            let unitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
            return (Calendar.current as NSCalendar).components(unitFlags, from: self.underlyingNSDate)
        }
        set {
            self.underlyingNSDate = Calendar(identifier: Calendar.Identifier.gregorian).date(from: newValue)
        }
    }
    
    // MARK: Date Components
    fileprivate mutating func setComponent(_ newValue: AnyObject?, componentKey: String) {
        let dateCmps = self.underlyingDateComponents;
        (dateCmps as NSDateComponents).setValue(newValue, forKey: componentKey)
        self.underlyingDateComponents = dateCmps
    }
    
    public var Year: Int {
        get { return self.underlyingDateComponents.year! }
        set { self.setComponent(newValue as AnyObject, componentKey: "Year") }
    }
    
    public var Month: Int {
        get { return self.underlyingDateComponents.month! }
        set { self.setComponent(newValue as AnyObject, componentKey: "Month") }
    }
    
    public var Day: Int {
        get { return self.underlyingDateComponents.day! }
        set { self.setComponent(newValue as AnyObject, componentKey: "Day") }
    }
    
    public var Hour: Int {
        get { return self.underlyingDateComponents.hour! }
        set { self.setComponent(newValue as AnyObject, componentKey: "Hour") }
    }
    
    public var Minute: Int {
        get { return self.underlyingDateComponents.minute! }
        set { self.setComponent(newValue as AnyObject, componentKey: "Minute") }
    }
    
    public var Second: Int {
        get { return self.underlyingDateComponents.second! }
        set { self.setComponent(newValue as AnyObject, componentKey: "Second") }
    }
    
    public var TimeZone: Foundation.TimeZone {
        get { return (self.underlyingDateComponents as NSDateComponents).timeZone! }
        set { self.setComponent(newValue as AnyObject, componentKey: "TimeZone") }
    }
    
    public static var Now: DateTime {
        get {
            return DateTime()
        }
    }
    
    // MARK: Initialization
    init() {
        self.underlyingNSDate = Date()
    }
    
    init(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, timeZone: Foundation.TimeZone = Foundation.TimeZone.current) {
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
        self.underlyingNSDate = Date(timeIntervalSince1970: ticks)
    }
    
    init(dateString: String, dateFormat: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        self.underlyingNSDate = dateFormatter.date(from: dateString)
    }
    
    init(nsDate: Date?) {
        if (nsDate == nil) {
            self.underlyingNSDate = Date()
        } else {
            self.underlyingNSDate = nsDate
        }
    }
    
    // MARK: Properties
    public var TimeOfDay: TimeSpan {
        return TimeSpan(hours: self.Hour, minutes: self.Minute, seconds: self.Second)
    }
    
    // MARK: Helper Functions
    func ToNSDate() -> Date {
        return self.underlyingNSDate
    }
    
    func Within(_ date1: DateTime, date2: DateTime) -> Bool {
        return (date1 > self && self > date2) || (date2 > self && self > date1)
    }
    
    mutating func Add(_ seconds: Int) {
        self.underlyingNSDate = self.underlyingNSDate.addingTimeInterval(Double(seconds))
    }
    
    mutating func AddMinutes(_ minutes: Int) {
        self.Add(minutes * 60)
    }
    
    public func ToString(_ dateFormat: String = "yyyy/MM/dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self.underlyingNSDate)
    }
}

// MARK: NSDate Comparisons
public func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs == rhs || lhs.compare(rhs) == .orderedSame
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}

extension Date: Comparable { }

// MARK: DateTime Comparisons

public func ==(lhs: DateTime, rhs: DateTime) -> Bool {
    return lhs.ToNSDate() == rhs.ToNSDate()
}

public func <(lhs: DateTime, rhs: DateTime) -> Bool {
    return lhs.ToNSDate() < rhs.ToNSDate()
}
