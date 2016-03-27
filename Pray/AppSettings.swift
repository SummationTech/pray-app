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
    var TimeBetweenNotificationsIndex: Int
    
    struct PropertyKey {
        static let TimeBetweenNotificationsKey = "time"
    }
    
    // MARK: Archiving Paths
    // ==================================================
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("settings")
    
    // MARK: Initialization
    // ==================================================
    init(timeBetweenNotifications: Int) {
        self.TimeBetweenNotificationsIndex = timeBetweenNotifications
        
        super.init()
    }
    
    // MARK: NSCoding Members
    // ==================================================
    required convenience init?(coder aDecoder: NSCoder) {
        let timeBetweenNotifications = aDecoder.decodeIntegerForKey(PropertyKey.TimeBetweenNotificationsKey)
        
        self.init(timeBetweenNotifications: timeBetweenNotifications)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(TimeBetweenNotificationsIndex, forKey: PropertyKey.TimeBetweenNotificationsKey)
    }
}