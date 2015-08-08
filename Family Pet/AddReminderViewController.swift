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
    
    @IBOutlet var petPickerView: AKPickerView!
    
    @IBOutlet var typeControl: ADVSegmentedControl!
    @IBOutlet var frequencyControl: ADVSegmentedControl!
    @IBOutlet var queueControl: ADVSegmentedControl!
    
    var delegate: ReminderScrollView!
    
//    var petNames = ["Tokyo", "Kanagawa", "Osaka", "Aichi", "Saitama", "Chiba", "Hyogo", "Hokkaido", "Fukuoka", "Shizuoka"]
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
        
    }
    
    func loadData(){
        let user = PFUser.currentUser()
        let query = PFQuery(className: "Pet")
        query.whereKey("owners", equalTo: user!)
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
    
    
    func typeValueChanged(sender: AnyObject?){
        reminderType = ReminderType(rawValue: typeControl.selectedIndex)!
    }
    
    func frequencyValueChanged(sender: AnyObject?){
        reminderFrequency = ReminderFrequency(rawValue: frequencyControl.selectedIndex)!
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
