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
    @IBOutlet weak var IntervalSelector: UISegmentedControl!
    @IBOutlet weak var EarliestTimeSelector: UISegmentedControl!
    @IBOutlet weak var LatestTimeSelector: UISegmentedControl!
    
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
            self.EarliestTimeSelector.setTitle("6:00 AM", forSegmentAtIndex: 0)
            self.EarliestTimeSelector.setTitle("7:00 AM", forSegmentAtIndex: 1)
            self.EarliestTimeSelector.setTitle("8:00 AM", forSegmentAtIndex: 2)
            self.EarliestTimeSelector.setTitle("9:00 AM", forSegmentAtIndex: 3)
            
            self.LatestTimeSelector.setTitle("7:00 PM", forSegmentAtIndex: 0)
            self.LatestTimeSelector.setTitle("8:00 PM", forSegmentAtIndex: 1)
            self.LatestTimeSelector.setTitle("9:00 PM", forSegmentAtIndex: 2)
            self.LatestTimeSelector.setTitle("10:00 PM", forSegmentAtIndex: 3)
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
    @IBAction func onTimeIntervalSelector_valuechange(sender: AnyObject) {
        self.updateSettings()
    }
    
    @IBAction func onStartTimeSelector_valuechange(sender: AnyObject) {
        self.updateSettings()
    }
    
    @IBAction func onEndTimeSelector_valuechange(sender: AnyObject) {
        self.updateSettings()
    }
    
    // MARK: Class Variables
    // ==================================================
    let possibleNotificationIntervals = [30, 60, 120, 180, 240]
    
    let possibleEndTimes = [
        DateTime(hour: 19).TimeOfDay,
        DateTime(hour: 20).TimeOfDay,
        DateTime(hour: 21).TimeOfDay,
        DateTime(hour: 22).TimeOfDay,
        ]
    
    let possibleStartTimes = [
        DateTime(hour: 6).TimeOfDay,
        DateTime(hour: 7).TimeOfDay,
        DateTime(hour: 8).TimeOfDay,
        DateTime(hour: 9).TimeOfDay,
        ]
    
    // MARK: Helper Methods
    // ==================================================
    func loadSettings() {
        self.appSettings = NSKeyedUnarchiver.unarchiveObjectWithFile(AppSettings.ArchiveURL.path!) as? AppSettings
        
        if self.appSettings == nil {
            return
        }
        
        // Restore the selector states
        self.IntervalSelector.selectedSegmentIndex = self.possibleNotificationIntervals.indexOf(self.appSettings!.NotificationInterval)!
        self.EarliestTimeSelector.selectedSegmentIndex = self.possibleStartTimes.indexOf(self.appSettings!.EarliestTime)!
        self.LatestTimeSelector.selectedSegmentIndex = self.possibleEndTimes.indexOf(self.appSettings!.LatestTime)!
    }
    
    func updateSettings() {
        // Only continue if all selectors are selected
        if (self.IntervalSelector.selectedSegmentIndex != -1 ||
            self.EarliestTimeSelector.selectedSegmentIndex != -1 ||
            self.LatestTimeSelector.selectedSegmentIndex != -1) {
            return
        }
        
        // Ensure that we can send notifications
        if let currentNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings() {
            if (!currentNotificationSettings.types.contains(.Alert)) {
                NotificationManager.RegisterNotificationSettings()
            }
        }
        
        if self.appSettings == nil {
            self.appSettings = AppSettings(notificationInterval: 30,
                                           earliestTime: DateTime(hour: 8).TimeOfDay,
                                           latestTime: DateTime(hour: 21).TimeOfDay)
        }
        
        self.appSettings?.NotificationInterval = self.possibleNotificationIntervals[self.IntervalSelector.selectedSegmentIndex]
        self.appSettings?.EarliestTime = self.possibleStartTimes[self.EarliestTimeSelector.selectedSegmentIndex]
        self.appSettings?.LatestTime = self.possibleEndTimes[self.LatestTimeSelector.selectedSegmentIndex]
        
        NSKeyedArchiver.archiveRootObject(self.appSettings!, toFile: AppSettings.ArchiveURL.path!)
        
        // Update periodic notifications
        self.setIntervalNotifications()
    }
    
    func setIntervalNotifications() {
        NotificationManager.ClearNotifications()
        NotificationManager.CreateNotificationsForTimeInterval(self.appSettings!.NotificationInterval,
                                                               earliestTime: self.appSettings!.EarliestTime,
                                                               latestTime: self.appSettings!.LatestTime)
    }
}
