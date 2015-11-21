//
//  NotificationHandler.swift
//  Pray
//
//  Created by Sumner Evans on 2015/11/20.
//  Copyright © 2015 SummationTech. All rights reserved.
//

import Foundation
import UIKit

class NotificationManager {
    var NotificationIds: [Int] {
        get {
            let notifications = UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification]
            var returnArray = [Int]()
            for notification in notifications {
                returnArray.append(notification.userInfo!["NotificationId"] as! Int)
            }
            
            return returnArray
        }
    }
    
    func addNotification(fireDate: NSDate) {
        // Only allow 64 local notifications
        if NotificationIds.capacity > 64 {
            return
        }
        
        let notificationId = self.getNextNotificationId()
        
        // Create a local notification
        let notification = UILocalNotification()
        notification.alertBody = "Time to Pray!"
        notification.alertAction = "dismiss" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = fireDate
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["NotificationId": notificationId]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func clearNotifications(notificationIds: [Int]? = nil) {
        let notificationIdsToCancel = notificationIds == nil ? NotificationIds : notificationIds
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            if notificationIdsToCancel!.contains(notification.userInfo!["NotificationId"] as! Int) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
    
    func createNotificationsForTimeInterval(intervalInMinutes: Int?) {
        if let unwrappedIntervalInMinutes = intervalInMinutes {
            let intervalInSeconds = Double(unwrappedIntervalInMinutes * 60)
            self.addNotification(NSDate(timeIntervalSinceNow: intervalInSeconds))
            self.addNotification(NSDate(timeIntervalSinceNow: intervalInSeconds * 2))
        }
    }
    
    func getNextNotificationId() -> Int {
        return NotificationIds.capacity > 0 ? NotificationIds.maxElement()! + 1 : 1
    }
}