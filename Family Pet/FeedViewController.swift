//
//  FeedViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

let globalNotificationKey = "com.canalesb.globalKey"
let reloadRequestNotificationKey = "com.canalesb.reloadRequestKey"
let friendsReloadNotificationKey = "com.canalesb.friendsReloadKey"

var reminders: [Reminder] = []
var pets = [Pet]()

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: globalNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "globalReload", name: reloadRequestNotificationKey, object: nil)
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.addPullToRefresh({ [weak self] in
            self!.globalReload()
        })
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Reload the wall
        globalReload()
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
                        reminders = objects
                        NSNotificationCenter.defaultCenter().postNotificationName(globalNotificationKey, object: self)
                        self.tableView.stopPullToRefresh()
                    }
                } else {
                    println("Error loading pets: \(error)")
                }
                
            }
        }
    }
    
    func loadPets(){
        let user = PFUser.currentUser()
        let query = PFQuery(className: "Pet")
        if let user = user {
            query.whereKey("owners", equalTo: user)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    if let objects = objects as? [Pet] {
                        pets = objects
                        NSNotificationCenter.defaultCenter().postNotificationName(globalNotificationKey, object: self)
                    }
                } else {
                    println("Error loading pets: \(error)")
                }
                
            }
        }
        
    }
    
    func reloadData(){
        self.tableView.reloadData()
    }
    
    func globalReload(){
        loadReminders()
        loadPets()
    }
    
    // MARK: - Table Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "PresentCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! FeedTableViewCell
        
        let reminder = reminders[indexPath.row]
        
        //        cell.petProfile.layer.cornerRadius = cell.petProfile.frame.size.width / 2;
        cell.typeIcon.clipsToBounds = true
        //        cell.petProfile.layer.borderWidth = 6.0;
        //        cell.petProfile.layer.borderColor = UIColor(netHex: 0x4C4C4F).CGColor
        cell.typeIcon.image = reminder.getIcon()
        cell.statusIcon.image = reminder.getStatusIcon()
        
        
        
        // load image
        //        if pet.image != nil {
        //            cell.petProfile.contentMode = UIViewContentMode.ScaleToFill
        //            cell.petProfile.file = pet.image
        //            cell.petProfile.loadInBackground(nil) { percent in
        //                cell.progressView.progress = Float(percent)*0.01
        //                // println("\(percent)%")
        //            }
        //        }
        
        
        
        cell.title.attributedText = reminder.getName()
        cell.date.text = "today at \(reminder.getTime())"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! FeedTableViewCell
        let reminder = reminders[indexPath.row]
        reminder.completed = !reminder.completed
        reminder.saveEventually()
        cell.statusIcon.image = reminder.getStatusIcon()
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
