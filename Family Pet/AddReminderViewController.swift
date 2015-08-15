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
    var weekday:Int = 0
    
    @IBOutlet var typeControl: ADVSegmentedControl!
    @IBOutlet var frequencyControl: ADVSegmentedControl!
    @IBOutlet var queueControl: ADVSegmentedControl!
    @IBOutlet var weekdayControl: ADVSegmentedControl!
    
    @IBOutlet var weekdayControlHeightConstraint: NSLayoutConstraint!
    var pickerController: RMDateSelectionViewController?
    
    @IBOutlet var dateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        // reminderDate = NSDate().dateByAddingDays(1)
        
        // Add reload observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: globalNotificationKey, object: nil)
        
        // Configure segment controls
        typeControl.items = ["feed", "play", "walk", "vet", "meds"]
        typeControl.selectedIndex = 0
        typeControl.addTarget(self, action: "typeValueChanged:", forControlEvents: .ValueChanged)

        frequencyControl.items = ["once", "daily", "weekly"]
        frequencyControl.selectedIndex = 0
        frequencyControl.addTarget(self, action: "frequencyValueChanged:", forControlEvents: .ValueChanged)
        
        weekdayControl.items = ["S", "M", "T", "W", "Th", "F", "S"]
        weekdayControl.frame.size.height = CGFloat(0.0)
        weekdayControl.addTarget(self, action: "weekdayValueChanged:", forControlEvents: .ValueChanged)
        hideWeekdayControl()
        
        queueControl.items = ["daily", "weekly"]
        queueControl.selectedIndex = 0
        queueControl.addTarget(self, action: "queueValueChanged:", forControlEvents: .ValueChanged)
        
        // Configure Date Picker
        
        let selectAction = RMAction(title: "Select", style: RMActionStyle.Done) { (controller) -> Void in
            if let dateController = controller.contentView as? UIDatePicker {
                self.setDateButtonTitle(dateController.date)
            }
        }
        let cancelAction = RMAction(title: "Cancel", style: RMActionStyle.Cancel) { (controller) -> Void in
            
        }
        pickerController = RMDateSelectionViewController(style: RMActionControllerStyle.White, selectAction: selectAction, andCancelAction: cancelAction)
        pickerController!.title = "Select Date"
        pickerController!.message = "Select the date for your reminder."
        pickerController?.datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        pickerController?.datePicker.minimumDate = NSDate()
        
        dateButton.layer.borderWidth = 3
        dateButton.layer.borderColor = UIColor(netHex: 0x74747B).CGColor
        
        reloadData()
    }
    
    func setDateButtonTitle(date: NSDate){
        self.reminderDate = date
        var dateString:String
        if self.reminderFrequency == ReminderFrequency.Once {
            dateString = date.toString(format: .Custom("EEEE, MMM d, h:mm a"))
        } else {
            dateString = date.toString(format: .Custom("h:mm a"))
        }
        self.dateButton.setTitle(dateString, forState: .Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func reloadData(){
        pet = selectedPet
    }
    
    // MARK: Segment Event Functions
    
    func typeValueChanged(sender: AnyObject?){
        reminderType = ReminderType(rawValue: typeControl.selectedIndex)!
    }
    
    // Changes whole view depending on which frequency is slelected
    func frequencyValueChanged(sender: AnyObject?){
        reminderFrequency = ReminderFrequency(rawValue: frequencyControl.selectedIndex)!
        
        if reminderFrequency == ReminderFrequency.Once { // ONCE
            pickerController!.title = "Select Date"
            pickerController!.message = "Select the date for your reminder."
            pickerController?.datePicker.datePickerMode = UIDatePickerMode.DateAndTime
            hideWeekdayControl()
            pickerController?.datePicker.minimumDate = NSDate()

        } else if reminderFrequency == ReminderFrequency.Daily { // DAILY
            pickerController!.title = "Select Time"
            pickerController!.message = "Select the time for your reminder."
            pickerController?.datePicker.datePickerMode = UIDatePickerMode.Time
            hideWeekdayControl()
            pickerController?.datePicker.minimumDate = nil
            
        } else if reminderFrequency == ReminderFrequency.Weekly { // WEEKLY
            pickerController!.title = "Select Time"
            pickerController!.message = "Select the time for your reminder."
            pickerController?.datePicker.datePickerMode = UIDatePickerMode.Time
            showWeekdayControl()
            pickerController?.datePicker.minimumDate = nil
        }
        if let date = self.reminderDate {
            setDateButtonTitle(date)
        }
    }
    
    func queueValueChanged(sender: AnyObject?){
        reminderQueue = ReminderQueue(rawValue: queueControl.selectedIndex)!
    }
    
    func weekdayValueChanged(sender: AnyObject?){
        weekday = weekdayControl.selectedIndex
    }
    
    // MARK: PickerView Functions
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        pet = pets[item]
    }

    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return pets.count
    }

    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return pets[item].name
    }
    
    // MARK: Action Functions
    
    @IBAction func setDate(sender: AnyObject) {
        presentViewController(pickerController!, animated: true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        self.showWaitOverlay()
        self.saveReminder()
    }
    @IBAction func cancel(sender: AnyObject) {
        let button = sender as! UIButton
        button.animateSlingPress()
        dismissViewControllerAnimated(true, completion: { () -> Void in })
    }
    
    func saveReminder() {
        if reminderDate != nil {
            let reminder = Reminder(user: PFUser.currentUser()!, pet: pet!, type: reminderType, date: reminderDate!, weekday: weekday, frequency: reminderFrequency, queue: reminderQueue)
            reminder.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if succeeded {
                    // self.clearData()
                    NSNotificationCenter.defaultCenter().postNotificationName(reloadRequestNotificationKey, object: self)
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in })
                } else {
                    if let error = error {
                        if error.code == PFErrorCode.ValidationError.rawValue {
                            println("Date must be in the future!")
                        }
                    }
                }
                self.removeAllOverlays()

            }
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper Functions
    
    func getDayOfWeek()->Int? {
        let todayDate = NSDate()
        let myCalendar = NSCalendar()
        let myComponents = myCalendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func hideWeekdayControl(){
        self.view.layoutIfNeeded()
        weekday = 0
        weekdayControl.selectedIndex = weekday
        UIView.animateWithDuration(0.3) {

            self.weekdayControlHeightConstraint.constant = CGFloat(0.0)
            self.view.layoutIfNeeded()
        }
        
    }
    
    func showWeekdayControl(){
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.3) {

            self.weekdayControlHeightConstraint.constant = CGFloat(35.0)
            self.view.layoutIfNeeded()
        }
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
