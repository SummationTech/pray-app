//
//  ViewController.swift
//  Pray
//
//  Created by Sumner Evans on 2015/11/12.
//  Copyright © 2015 SummationTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // References
    // ==================================================
    @IBOutlet weak var EveryNSelector: UISegmentedControl!
    @IBOutlet weak var AndOrNotSelector: UISegmentedControl!
    @IBOutlet weak var TimeSelector: UISegmentedControl!
    @IBOutlet weak var TimeLabel: UILabel!
    
    // Initialization
    // ==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timeFormatString = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: NSLocale.currentLocale())!
        let is12HrTime = timeFormatString.containsString("a")
        
        if (is12HrTime) {
            self.TimeLabel.text = "9:00 AM - 9:00 PM"
        }
        
        // Restore the values of the segemented controls
        self.EveryNSelector.selectedSegmentIndex = 1
        self.AndOrNotSelector.selectedSegmentIndex = 1
        self.TimeSelector.selectedSegmentIndex = 1
        
        self.setSelectorState(self.AndOrNotSelector.selectedSegmentIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Event Handlers
    // ==================================================
    @IBAction func onEveryNSelector_valuechange(sender: AnyObject) {
        print(self.EveryNSelector.selectedSegmentIndex)
        
        switch (self.EveryNSelector.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        default:
            // TODO: Blow up
            break;
        }
    }
    
    @IBAction func onAndOrNotSelector_valuechange(sender: AnyObject) {
        self.setSelectorState(self.AndOrNotSelector.selectedSegmentIndex)
    }
    
    @IBAction func onTimeSelector_valuechange(sender: AnyObject) {
        print(self.TimeSelector.selectedSegmentIndex)
        
        switch (self.TimeSelector.selectedSegmentIndex) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            // TODO: Blow up
            break;
        }
    }

    // Helper Methods
    // ==================================================
    func setSelectorState(state: AndOrNotSelectorState) {
        switch (state) {
        case .And:
            self.EveryNSelector.enabled = true
            self.TimeSelector.enabled = true
            break;
        case .Or:
            self.EveryNSelector.enabled = false
            self.TimeSelector.enabled = true
            break;
        case .ButNot:
            self.EveryNSelector.enabled = true
            self.TimeSelector.enabled = false
        }
    }
    
    func setSelectorState(state: Int) {
        self.setSelectorState(AndOrNotSelectorState(rawValue: state)!)
    }
}
