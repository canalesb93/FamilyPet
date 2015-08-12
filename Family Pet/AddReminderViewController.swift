//
//  AddReminderViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/7/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

class AddReminderViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate  {

    var reminderType: ReminderType = ReminderType.Feed
    var reminderFrequency: ReminderFrequency = ReminderFrequency.Once
    var reminderQueue: ReminderQueue = ReminderQueue.Daily
    var pet: Pet?
    var reminderDate: NSDate?
    
    @IBOutlet var petPickerView: AKPickerView!
    
    @IBOutlet var typeControl: ADVSegmentedControl!
    @IBOutlet var frequencyControl: ADVSegmentedControl!
    @IBOutlet var queueControl: ADVSegmentedControl!
    var pickerController: RMDateSelectionViewController?
    
    @IBOutlet var dateButton: UIButton!
    var delegate: ReminderScrollView!
    
    var pets = [Pet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure segment controls
        typeControl.items = ["feed", "play", "walk", "vet", "meds"]
        typeControl.selectedIndex = 0
        typeControl.addTarget(self, action: "typeValueChanged:", forControlEvents: .ValueChanged)
        

        frequencyControl.items = ["once", "daily", "weekly"]
        frequencyControl.selectedIndex = 0
        frequencyControl.addTarget(self, action: "frequencyValueChanged:", forControlEvents: .ValueChanged)
        
        queueControl.items = ["daily", "weekly"]
        queueControl.selectedIndex = 0
        queueControl.addTarget(self, action: "queueValueChanged:", forControlEvents: .ValueChanged)
        
        // Configure pet Picker
        self.petPickerView.delegate = self
        self.petPickerView.dataSource = self
        
        self.petPickerView.font = UIFont(name: "HelveticaNeue-Light", size: 25)!
        self.petPickerView.highlightedFont = UIFont(name: "HelveticaNeue-Light", size: 25)!
        self.petPickerView.textColor = UIColor(netHex: 0x4C4C4F)
        self.petPickerView.highlightedTextColor = UIColor(netHex: 0x4C4C4F)
        self.petPickerView.pickerViewStyle = .Wheel
        self.petPickerView.maskDisabled = false
        self.petPickerView.reloadData()
        loadData()
        
        
        let selectAction = RMAction(title: "Select", style: RMActionStyle.Done) { (controller) -> Void in
            if let dateController = controller.contentView as? UIDatePicker {
                println(dateController.date)
                self.reminderDate = dateController.date

//                let formatter = NSDateFormatter()
//                formatter.dateStyle = NSDateFormatterStyle.
//                formatter.timeStyle = .MediumStyle
//                
//                let dateString = formatter.stringFromDate(dateController.date)
                
                let dayTimePeriodFormatter = NSDateFormatter()
                dayTimePeriodFormatter.dateFormat = "EEEE, MMM d, h:mm a"
                
                let dateString = dayTimePeriodFormatter.stringFromDate(self.reminderDate!)
                
                self.dateButton.setTitle(dateString, forState: .Normal)
            }
        }
        let cancelAction = RMAction(title: "Cancel", style: RMActionStyle.Cancel) { (controller) -> Void in
            
        }
        pickerController = RMDateSelectionViewController(style: RMActionControllerStyle.White, selectAction: selectAction, andCancelAction: cancelAction)
        pickerController!.title = "Select Date"
        pickerController!.message = "Select the date for your reminder."

        
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    func loadData(){
        let current_user = PFUser.currentUser()
        let query = PFQuery(className: "Pet")
        if let user = current_user{
            query.whereKey("owners", equalTo: user)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let objects = objects as? [Pet] {
                    self.pets = objects
                    self.pet = self.pets.first
                    self.petPickerView.reloadData()
                }
            } else {
                println("Error loading pets: \(error)")
            }
            
            }
        }
        
    }
    
    @IBAction func setDate(sender: AnyObject) {
        presentViewController(pickerController!, animated: true, completion: nil)
    }
    
    func typeValueChanged(sender: AnyObject?){
        reminderType = ReminderType(rawValue: typeControl.selectedIndex)!
    }
    
    func frequencyValueChanged(sender: AnyObject?){
        reminderFrequency = ReminderFrequency(rawValue: frequencyControl.selectedIndex)!
        if frequencyControl.selectedIndex == ReminderFrequency.Daily.rawValue {
            pickerController!.title = "Select Time"
            pickerController!.message = "Select the time for your reminder."
            pickerController?.datePicker.datePickerMode = UIDatePickerMode.Time
        } else if frequencyControl.selectedIndex == ReminderFrequency.Weekly.rawValue {
            pickerController!.title = "Select Date"
            pickerController!.message = "Select the weekday and time for your reminder. Ignore the month."
            pickerController?.datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        }else {
            pickerController?.datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        }
    }
    
    func queueValueChanged(sender: AnyObject?){
        reminderQueue = ReminderQueue(rawValue: queueControl.selectedIndex)!
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        pet = pets[item]
    }

    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.pets.count
    }

    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.pets[item].name
    }
    
    @IBAction func save(sender: AnyObject) {
        getMembersAndSave()
    }
    @IBAction func cancel(sender: AnyObject) {
        self.delegate!.moveToView(0)
    }
    
    func getMembersAndSave(){
        let relation = pet!.relationForKey("owners")
        let query = relation.query()
        query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    self.saveReminder(objects)
                }
            } else {
                println("Error loading pets: \(error)")
            }
            
        }
    }
    
    func saveReminder(members: [PFUser]) {
        
        let reminder = Reminder(user: PFUser.currentUser()!, pet: pet!, type: reminderType, date: reminderDate!, frequency: reminderFrequency, queue: reminderQueue)
        let reminderRelation = reminder.relationForKey("members")
        for member in members {
            reminderRelation.addObject(member)
        }
        reminder.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                // self.clearData()
                self.delegate!.moveToView(0)
            } else {
                //4
                if error != nil {
                    println("Error: \(error?.description)")
                    //                    self.showErrorView(error!)
                }
            }
        }
        
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
