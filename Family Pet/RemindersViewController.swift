//
//  RemindersViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

class RemindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: ReminderScrollView!

    var reminders: [Reminder] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.addPullToRefresh({ [weak self] in
            self!.loadReminders()
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Reload the wall
        loadReminders()
    }
    
    func loadReminders(){
        let user = PFUser.currentUser()
        let query = PFQuery(className: "Reminder")
        query.includeKey("pet")
        if let user = user {
            query.whereKey("members", equalTo: user)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    if let objects = objects as? [Reminder] {
                        self.reminders = objects
                        self.tableView.reloadData()
                        self.tableView.stopPullToRefresh()
                    }
                } else {
                    println("Error loading pets: \(error)")
                }
                
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "ReminderCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! ReminderTableViewCell
        
        let reminder = reminders[indexPath.row]

//        cell.petProfile.layer.cornerRadius = cell.petProfile.frame.size.width / 2;
        cell.icon.clipsToBounds = true
//        cell.petProfile.layer.borderWidth = 6.0;
//        cell.petProfile.layer.borderColor = UIColor(netHex: 0x4C4C4F).CGColor
        cell.icon.image = reminder.getIcon()
        
        
        // load image
//        if pet.image != nil {
//            cell.petProfile.contentMode = UIViewContentMode.ScaleToFill
//            cell.petProfile.file = pet.image
//            cell.petProfile.loadInBackground(nil) { percent in
//                cell.progressView.progress = Float(percent)*0.01
//                // println("\(percent)%")
//            }
//        }
        
        

        cell.name.attributedText = reminder.getName()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Selected row at index: \(indexPath.row)")
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
