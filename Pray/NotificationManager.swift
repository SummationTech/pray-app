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
        case Later = "Later"
        
        static let AllValues = [Done, Later]
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
            case getActionidentifier(ActionTitles.Later):
                // TODO: STUFF
                break
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
    
    static private func addNotification(fireDate: NSDate, notificationText: String) {
        // Only allow 64 local notifications
        if NotificationIds.capacity > 64 {
            return
        }
        
        // Create a local notification
        let notification = UILocalNotification()
        notification.alertBody = notificationText
        notification.fireDate = fireDate
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["NotificationId": self.getNextNotificationId()]
        notification.category = timeToPrayCategoryIdentifier
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static func ClearNotifications(notificationIds: [Int]? = nil) {
        let notificationIdsToCancel = notificationIds == nil ? NotificationIds : notificationIds
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            if notificationIdsToCancel!.contains(notification.userInfo!["NotificationId"] as! Int) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
    
    static func CreateNotificationsForTimeInterval(intervalInMinutes: Int?) {
        if let unwrappedIntervalInMinutes = intervalInMinutes {
            let intervalInSeconds = Double(unwrappedIntervalInMinutes * 60)
            
            // TODO: Change text according to user's wishes
            for i: Int in 1 ..< 50 {
                addNotification(NSDate(timeIntervalSinceNow: intervalInSeconds * Double(i)), notificationText: "Time to Pray!")
            }
        }
    }
    
    static private func getNextNotificationId() -> Int {
        return NotificationIds.capacity > 0 ? NotificationIds.maxElement()! + 1 : 1
    }
}