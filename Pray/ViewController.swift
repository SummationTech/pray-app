//
//  ViewController.swift
//  Pray
//
//  Created by Sumner Evans on 2015/11/12.
//  Copyright © 2015 SummationTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: References
    // ==================================================
    @IBOutlet weak var NumberOfUnlocksBetweenNotifications: UISegmentedControl!
    @IBOutlet weak var AndOrNotSelector: UISegmentedControl!
    @IBOutlet weak var TimeSelector: UISegmentedControl!
    @IBOutlet weak var TimeLabel: UILabel!
    
    // MARK: Properties
    // ==================================================
    var appSettings: AppSettings?
    var notificationManager: NotificationManager = NotificationManager()
    
    // MARK: Initialization
    // ==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timeFormatString = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: NSLocale.currentLocale())!
        let is12HrTime = timeFormatString.containsString("a")
        
        if (is12HrTime) {
            self.TimeLabel.text = "9:00 AM - 9:00 PM"
        }
        
        self.loadSettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Event Handlers
    // ==================================================
    @IBAction func onNumberOfUnlocksBetweenNotifications_valuechange(sender: AnyObject) {
        self.updateSettings()
    }
    
    @IBAction func onAndOrNotSelector_valuechange(sender: AnyObject) {
        self.setSelectorState(self.AndOrNotSelector.selectedSegmentIndex)
        self.updateSettings()
    }
    
    @IBAction func onTimeSelector_valuechange(sender: AnyObject) {
        self.updateSettings()
    }

    // MARK: Helper Methods
    // ==================================================
    func loadSettings() {
        self.appSettings = NSKeyedUnarchiver.unarchiveObjectWithFile(AppSettings.ArchiveURL.path!) as? AppSettings
        
        if (self.appSettings == nil) {
            return
        }
        
        // Restore the values of the segemented controls
        self.NumberOfUnlocksBetweenNotifications.selectedSegmentIndex = (self.appSettings?.NumberOfUnlocksBetweenNotifications)!
        self.AndOrNotSelector.selectedSegmentIndex = (self.appSettings?.AndOrNot)!
        self.TimeSelector.selectedSegmentIndex = (self.appSettings?.TimeBetweenNotifications)!
        
        self.setSelectorState(self.AndOrNotSelector.selectedSegmentIndex)
    }
    
    func setSelectorState(state: AndOrNotSelectorState) {
        switch (state) {
        case .And:
            self.NumberOfUnlocksBetweenNotifications.enabled = true
            self.TimeSelector.enabled = true
            break;
        case .Or:
            self.NumberOfUnlocksBetweenNotifications.enabled = false
            self.TimeSelector.enabled = true
            break;
        case .ButNot:
            self.NumberOfUnlocksBetweenNotifications.enabled = true
            self.TimeSelector.enabled = false
        }
    }
    
    func setSelectorState(state: Int) {
        self.setSelectorState(AndOrNotSelectorState(rawValue: state)!)
    }
    
    func updateSettings() {
        if (self.appSettings == nil) {
            self.appSettings = AppSettings(n: 0, andOrNot: 0, timeBetweenNotifications: 0)
        }
        
        self.appSettings?.NumberOfUnlocksBetweenNotifications = self.NumberOfUnlocksBetweenNotifications.selectedSegmentIndex
        self.appSettings?.AndOrNot = self.AndOrNotSelector.selectedSegmentIndex
        self.appSettings?.TimeBetweenNotifications = self.TimeSelector.selectedSegmentIndex
        
        var intervalInMinutes: Int? = nil
        switch self.appSettings!.NumberOfUnlocksBetweenNotifications {
        case 0:
            intervalInMinutes = 30
            break;
        case 1:
            intervalInMinutes = 60
            break;
        case 2:
            intervalInMinutes = 120
            break;
        case 3:
            intervalInMinutes = 180
            break;
        case 4:
            intervalInMinutes = 240
            break;
        default:
            // TODO: Blow Up
            break;
        }
        
        notificationManager.createNotificationsForTimeInterval(intervalInMinutes)
        
        NSKeyedArchiver.archiveRootObject(self.appSettings!, toFile: AppSettings.ArchiveURL.path!)
    }
}
