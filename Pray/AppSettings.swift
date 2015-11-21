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
    var NumberOfUnlocksBetweenNotifications: Int
    var AndOrNot: Int
    var TimeBetweenNotifications: Int
    
    struct PropertyKey {
        static let NumberOfUnlocksBetweenNotificationsKey = "numberOfUnlocksBetweenNofications"
        static let AndOrNotKey = "andOrNot"
        static let TimeBetweenNotificationsKey = "time"
    }
    
    // MARK: Archiving Paths
    // ==================================================
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("settings")
    
    // MARK: Initialization
    // ==================================================
    init(n numberOfUnlocksBetweenNotifications: Int, andOrNot: Int, timeBetweenNotifications: Int) {
        self.NumberOfUnlocksBetweenNotifications = numberOfUnlocksBetweenNotifications
        self.AndOrNot = andOrNot
        self.TimeBetweenNotifications = timeBetweenNotifications
        
        super.init()
    }
    
    // MARK: NSCoding Members
    // ==================================================
    required convenience init?(coder aDecoder: NSCoder) {
        let numberOfUnlocksBetweenNofications = aDecoder.decodeIntegerForKey(PropertyKey.NumberOfUnlocksBetweenNotificationsKey)
        let andOrNot = aDecoder.decodeIntegerForKey(PropertyKey.AndOrNotKey)
        let timeBetweenNotifications = aDecoder.decodeIntegerForKey(PropertyKey.TimeBetweenNotificationsKey)
        
        self.init(n: numberOfUnlocksBetweenNofications, andOrNot: andOrNot, timeBetweenNotifications: timeBetweenNotifications)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(NumberOfUnlocksBetweenNotifications, forKey: PropertyKey.NumberOfUnlocksBetweenNotificationsKey)
        aCoder.encodeInteger(AndOrNot, forKey: PropertyKey.AndOrNotKey)
        aCoder.encodeInteger(TimeBetweenNotifications, forKey: PropertyKey.TimeBetweenNotificationsKey)
    }
}