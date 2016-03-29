//
//  NotificationHandler.swift
//  Pray
//
//  Created by Sumner Evans on 2015/11/20.
//  Copyright © 2015 SummationTech. All rights reserved.
//

import Foundation
import UIKit

class NotificationManager: NSObject {
    
    // Thanks to Yari D'areglia for notification action technique which is used throughout
    // this class and some in AppDelegate.
    // http://www.thinkandbuild.it/interactive-notifications-with-notification-actions/
    // https://github.com/ariok/TB_InteractiveNotifications/blob/master/TB_InteractiveNotifications/AppDelegate.swift
    
    enum ActionTitles: String {
        case Done = "Done"
        // REIMPLEMNT: for PRAY-6
        // case Later = "Later"
        
        // static let AllValues = [Done, Later]
        
        static let AllValues = [Done]
    }
    
    private static var timeToPrayCategoryIdentifier: String {
        get { return "TIME_TO_PRAY_CATEGORY" }
    }
    
    static private func getActionidentifier(actionTitle: ActionTitles) -> String {
        return "\(actionTitle.rawValue.uppercaseString)_ACTION"
    }
    
    
    // MARK: Initialization
    // ==================================================
    static func RegisterNotificationSettings() {
        var actions = [UIMutableUserNotificationAction]()
        
        for actionTitle in ActionTitles.AllValues {
            let action = UIMutableUserNotificationAction()
            action.identifier = getActionidentifier(actionTitle)
            action.title = actionTitle.rawValue
            action.activationMode = .Background
            action.destructive = false
            
            actions.append(action)
        }
        
        // Create the notification category
        let prayNowNotificationCategory = UIMutableUserNotificationCategory()
        prayNowNotificationCategory.identifier = timeToPrayCategoryIdentifier
        prayNowNotificationCategory.setActions(actions, forContext: .Default)
        prayNowNotificationCategory.setActions(actions, forContext: .Minimal)
        
        // Register Notification Settings
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: [prayNowNotificationCategory])
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    static func HandleNotificationAction(identifier: String?, notification: UILocalNotification, completionHandler: () -> Void) {
        if notification.category == timeToPrayCategoryIdentifier {
            switch identifier! {
            case getActionidentifier(ActionTitles.Done):
                // TODO: DO STUFF
                break
                
                // REIMPLEMNT: for PRAY-6
                // case getActionidentifier(ActionTitles.Later):
                // TODO: Delay the prayer by an amount of time
            //     break
            default:
                // TODO: BLOW UP
                break
            }
        }
    }
    
    static private var NotificationIds: [Int] {
        get {
            let notifications = UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification]
            var notificationIds = [Int]()
            for notification in notifications {
                notificationIds.append(notification.userInfo!["NotificationId"] as! Int)
            }
            
            return notificationIds
        }
    }
    
    static func AddNotification(fireDate: NSDate, notificationText: String) -> Int! {
        // Only allow 64 local notifications
        if NotificationIds.capacity > 64 {
            return nil
        }
        
        let notificationId = self.getNextNotificationId()
        
        // Create a local notification
        let notification = UILocalNotification()
        notification.alertBody = notificationText
        notification.fireDate = fireDate
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["NotificationId": notificationId]
        notification.category = timeToPrayCategoryIdentifier
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        return notificationId
    }
    
    static func ClearNotifications(notificationIds: [Int]? = nil) {
        let notificationIdsToCancel = notificationIds == nil ? self.NotificationIds : notificationIds
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            if notificationIdsToCancel!.contains(notification.userInfo!["NotificationId"] as! Int) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
    
    static func CreateNotificationsForTimeInterval(intervalInMinutes: Int?, earliestTime: TimeSpan, latestTime: TimeSpan) {
        if let unwrappedIntervalInMinutes = intervalInMinutes {
            // DEBUG:
            // let now = DateTime(hour: 9, minute: 0)
            
            let now = DateTime.Now
            
            // By default, start at 08:00 today
            var nextNotificationDate = DateTime(year: now.Year, month: now.Month, day: now.Day, hour: earliestTime.Hours)
            
            // Create 64 notifications, the maximum allowed.
            for i in 1 ..< 64 {
                if i > 1 {
                    nextNotificationDate.AddMinutes(unwrappedIntervalInMinutes)
                }
                
                while !notificationDateValid(nextNotificationDate, earliestTime: earliestTime, latestTime: latestTime) {
                    nextNotificationDate.AddMinutes(unwrappedIntervalInMinutes)
                }
                
                NotificationManager.AddNotification(nextNotificationDate.ToNSDate(), notificationText: "Time to Pray!")
            }
        }
    }
    
    static private func notificationDateValid(notificationDate: DateTime, earliestTime: TimeSpan, latestTime: TimeSpan) -> Bool {
        let earliestTime = earliestTime
        let latestTime = latestTime
        let notificationTime = notificationDate.TimeOfDay
        
        // DEBUG: 
        // return earliestTime <= notificationTime && notificationTime <= latestTime && notificationDate > DateTime(hour: 9, minute: 0)
        return earliestTime <= notificationTime && notificationTime <= latestTime && notificationDate > DateTime.Now
    }
    
    static private func getNextNotificationId() -> Int {
        return NotificationIds.capacity > 0 ? NotificationIds.maxElement()! + 1 : 1
    }
}