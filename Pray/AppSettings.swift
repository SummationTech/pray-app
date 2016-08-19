//
//  CurrentSettings.swift
//  Pray
//
//  Created by Sumner Evans on 2015/11/20.
//  Copyright © 2015 SummationTech. All rights reserved.
//

import Foundation
import UIKit

class AppSettings: NSObject, NSCoding {
    // MARK: Properties
    // ==================================================
    var NotificationInterval: Int!
    var EarliestTime: TimeSpan!
    var LatestTime: TimeSpan!
    
    struct PropertyKey {
        static let NotificationInterval = "notificationinterval"
        static let EarliestTime = "earliesttime"
        static let LatestTime = "latesttime"
    }
    
    // MARK: Archiving Paths
    // ==================================================
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("settings")
    
    // MARK: Initialization
    // ==================================================
    init(notificationInterval: Int, earliestTime: TimeSpan!, latestTime: TimeSpan!) {
        self.NotificationInterval = notificationInterval
        self.EarliestTime = earliestTime
        self.LatestTime = latestTime
        
        super.init()
    }
    
    // MARK: NSCoding Members
    // ==================================================
    required convenience init?(coder aDecoder: NSCoder) {
        let notificationInterval = aDecoder.decodeIntegerForKey(PropertyKey.NotificationInterval)
        let earliestTime = aDecoder.decodeObjectForKey(PropertyKey.EarliestTime) as! TimeSpan!
        let latestTime = aDecoder.decodeObjectForKey(PropertyKey.LatestTime) as! TimeSpan!
        
        self.init(notificationInterval: notificationInterval, earliestTime: earliestTime, latestTime: latestTime)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.NotificationInterval, forKey: PropertyKey.NotificationInterval)
        aCoder.encodeObject(self.EarliestTime, forKey: PropertyKey.EarliestTime)
        aCoder.encodeObject(self.LatestTime, forKey: PropertyKey.LatestTime)
    }
}