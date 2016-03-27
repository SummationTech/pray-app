//
//  ViewController.swift
//  Pray
//
//  Created by Sumner Evans on 2015/11/12.
//  Copyright © 2015 SummationTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    // ==================================================
    @IBOutlet weak var TimeSelector: UISegmentedControl!
    @IBOutlet weak var TimeLabel: UILabel!
    
    // MARK: Properties
    // ==================================================
    var appSettings: AppSettings?
    
    // MARK: Initialization
    // ==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timeFormatString = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: NSLocale.currentLocale())!
        let is12HrTime = timeFormatString.containsString("a")
        
        if is12HrTime {
            self.TimeLabel.text = "9:00 AM - 9:00 PM"
        }
        
        self.loadSettings()
    }
    
    // MARK: Destruction
    // ==================================================
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Event Handlers
    // ==================================================
    @IBAction func onTimeSelector_valuechange(sender: AnyObject) {
        self.updateSettings()
        
        // Update periodic notifications
        self.setIntervalNotifications()
    }
    
    // MARK: Helper Methods
    // ==================================================
    func loadSettings() {
        self.appSettings = NSKeyedUnarchiver.unarchiveObjectWithFile(AppSettings.ArchiveURL.path!) as? AppSettings
        
        if self.appSettings == nil {
            return
        }
        
        // Restore the values of the time selector control
        self.TimeSelector.selectedSegmentIndex = (self.appSettings?.TimeBetweenNotificationsIndex)!
    }
    
    func updateSettings() {
        // Ensure that we can send notifications
        if let currentNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings() {
            if (!currentNotificationSettings.types.contains(.Alert)) {
                NotificationManager.RegisterNotificationSettings()
            }
        }
        
        if self.appSettings == nil {
            self.appSettings = AppSettings(timeBetweenNotifications: 0)
        }
        
        self.appSettings?.TimeBetweenNotificationsIndex = self.TimeSelector.selectedSegmentIndex
        
        NSKeyedArchiver.archiveRootObject(self.appSettings!, toFile: AppSettings.ArchiveURL.path!)
    }
    
    func setIntervalNotifications() {
        let posibleIntervalsInMinutes = [30, 60, 120, 180, 240]
        let intervalInMinutes = posibleIntervalsInMinutes[self.appSettings!.TimeBetweenNotificationsIndex]
        
        NotificationManager.ClearNotifications()
        NotificationManager.CreateNotificationsForTimeInterval(1)
        NotificationManager.CreateNotificationsForTimeInterval(intervalInMinutes)
    }
}
