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
        
        let timeFormatString = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        let is12HrTime = timeFormatString.contains("a")
        
        if is12HrTime {
            self.EarliestTimeSelector.setTitle("6:00 AM", forSegmentAt: 0)
            self.EarliestTimeSelector.setTitle("7:00 AM", forSegmentAt: 1)
            self.EarliestTimeSelector.setTitle("8:00 AM", forSegmentAt: 2)
            self.EarliestTimeSelector.setTitle("9:00 AM", forSegmentAt: 3)
            
            self.LatestTimeSelector.setTitle("7:00 PM", forSegmentAt: 0)
            self.LatestTimeSelector.setTitle("8:00 PM", forSegmentAt: 1)
            self.LatestTimeSelector.setTitle("9:00 PM", forSegmentAt: 2)
            self.LatestTimeSelector.setTitle("10:00 PM", forSegmentAt: 3)
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
    @IBAction func onTimeIntervalSelector_valuechange(_ sender: AnyObject) {
        self.updateSettings()
    }
    
    @IBAction func onStartTimeSelector_valuechange(_ sender: AnyObject) {
        self.updateSettings()
    }
    
    @IBAction func onEndTimeSelector_valuechange(_ sender: AnyObject) {
        self.updateSettings()
    }
    
    // MARK: Class Variables
    // ==================================================
    let possibleNotificationIntervals = [30, 60, 120, 180, 240]
    
    let possibleEarliestTimes = [
        DateTime(hour: 6).TimeOfDay,
        DateTime(hour: 7).TimeOfDay,
        DateTime(hour: 8).TimeOfDay,
        DateTime(hour: 9).TimeOfDay,
        ]
    
    let possibleLatestTimes = [
        DateTime(hour: 19).TimeOfDay,
        DateTime(hour: 20).TimeOfDay,
        DateTime(hour: 21).TimeOfDay,
        DateTime(hour: 22).TimeOfDay,
        ]
    
    // MARK: Helper Methods
    // ==================================================
    func loadSettings() {
        self.appSettings = NSKeyedUnarchiver.unarchiveObject(withFile: AppSettings.ArchiveURL.path) as? AppSettings
        
        if self.appSettings == nil {
            return
        }
        
        // Restore the selector states
        self.IntervalSelector.selectedSegmentIndex = self.possibleNotificationIntervals.index(of: self.appSettings!.NotificationInterval)!
        
        for (i, time) in self.possibleEarliestTimes.enumerated() {
            if time.ToDateTime() == self.appSettings!.EarliestTime.ToDateTime() {
                self.EarliestTimeSelector.selectedSegmentIndex = i
            }
        }
        
        for (i, time) in self.possibleLatestTimes.enumerated() {
            if time.ToDateTime() == self.appSettings!.LatestTime.ToDateTime() {
                self.LatestTimeSelector.selectedSegmentIndex = i
            }
        }
        
        // Top off the notification queue.
        NotificationManager.CreateNotifications(self.appSettings!.NotificationInterval, earliestTime: self.appSettings!.EarliestTime, latestTime: self.appSettings!.LatestTime)
    }
    
    func updateSettings() {
        // Only continue if all selectors are selected
        if (self.IntervalSelector.selectedSegmentIndex == -1 ||
            self.EarliestTimeSelector.selectedSegmentIndex == -1 ||
            self.LatestTimeSelector.selectedSegmentIndex == -1) {
            return
        }
        
        // Ensure that we can send notifications
        if let currentNotificationSettings = UIApplication.shared.currentUserNotificationSettings {
            if (!currentNotificationSettings.types.contains(.alert)) {
                NotificationManager.RegisterNotificationSettings()
            }
        }
        
        if self.appSettings == nil {
            self.appSettings = AppSettings(notificationInterval: 30,
                                           earliestTime: DateTime(hour: 8).TimeOfDay,
                                           latestTime: DateTime(hour: 21).TimeOfDay)
        }
        
        self.appSettings?.NotificationInterval = self.possibleNotificationIntervals[self.IntervalSelector.selectedSegmentIndex]
        self.appSettings?.EarliestTime = self.possibleEarliestTimes[self.EarliestTimeSelector.selectedSegmentIndex]
        self.appSettings?.LatestTime = self.possibleLatestTimes[self.LatestTimeSelector.selectedSegmentIndex]
        
        NSKeyedArchiver.archiveRootObject(self.appSettings!, toFile: AppSettings.ArchiveURL.path)
        
        // Update periodic notifications
        self.setIntervalNotifications()
    }
    
    func setIntervalNotifications() {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        activityView.center = self.view.center
        
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        
        NotificationManager.ClearNotifications()
        NotificationManager.CreateNotifications(self.appSettings!.NotificationInterval,
                                                earliestTime: self.appSettings!.EarliestTime,
                                                latestTime: self.appSettings!.LatestTime)
        
        activityView.stopAnimating()

    }
}
