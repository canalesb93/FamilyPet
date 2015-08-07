//
//  AddReminderViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/7/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit

class AddReminderViewController: UIViewController {

    var reminderType: ReminderType = ReminderType.Feed
    var reminderFrequency: ReminderFrequency = ReminderFrequency.Once
    var reminderQueue: ReminderQueue = ReminderQueue.Daily
    
    @IBOutlet var typeControl: ADVSegmentedControl!
    @IBOutlet var frequencyControl: ADVSegmentedControl!
    @IBOutlet var queueControl: ADVSegmentedControl!
    
    var delegate: ReminderScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeControl.items = ["feed", "play", "walk", "vet", "meds"]
        typeControl.selectedIndex = 0
        typeControl.addTarget(self, action: "typeValueChanged:", forControlEvents: .ValueChanged)
        

        frequencyControl.items = ["once", "daily", "weekly"]
        frequencyControl.selectedIndex = 0
        frequencyControl.addTarget(self, action: "frequencyValueChanged:", forControlEvents: .ValueChanged)
        
        queueControl.items = ["daily", "weekly"]
        queueControl.selectedIndex = 0
        queueControl.addTarget(self, action: "queueValueChanged:", forControlEvents: .ValueChanged)
        
    }
    
    func typeValueChanged(sender: AnyObject?){
        reminderType = ReminderType(rawValue: typeControl.selectedIndex)!
    }
    
    func frequencyValueChanged(sender: AnyObject?){
        reminderFrequency = ReminderFrequency(rawValue: frequencyControl.selectedIndex)!
    }
    
    func queueValueChanged(sender: AnyObject?){
        reminderQueue = ReminderQueue(rawValue: typeControl.selectedIndex)!
    }

    @IBAction func save(sender: AnyObject) {
    }
    @IBAction func cancel(sender: AnyObject) {
        self.delegate!.moveToView(0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
