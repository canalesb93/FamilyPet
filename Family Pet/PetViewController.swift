//
//  PetViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/13/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

class PetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var petAttributesLabel: UILabel!
    @IBOutlet var petTypeLabel: UILabel!
    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var petProfile: PFImageView!
    @IBOutlet var tableView: UITableView!
    
    let sectionsInTable = ["owners", "reminders"]
    
    var owners = [PFUser]()
    var selected_reminders = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: globalNotificationKey, object: nil)

        
        petProfile.layer.cornerRadius = petProfile.frame.size.width / 2;
        petProfile.clipsToBounds = true
        petProfile.layer.borderWidth = 6.0;
        petProfile.layer.borderColor = UIColor(netHex: 0xE0D59F).CGColor
        
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(animated: Bool) {
        println("PETVIEW VIEWWILLDISAPPEAR")
        selectedPet = nil
        selected_reminders.removeAll(keepCapacity: false)
    }
    
    func reloadData(){
        loadData()
    }
    
    func loadData(){
        self.showWaitOverlay()
        if selectedPet != nil {
            self.navigationItem.title = selectedPet!.name
            petNameLabel.text = selectedPet!.name
            petTypeLabel.text = selectedPet?.getType()
            petAttributesLabel.text = selectedPet?.attributes
            
            petProfile.file = selectedPet?.image
            petProfile.loadInBackground()
            selected_reminders.removeAll(keepCapacity: false)
            for reminder in reminders {
                if reminder.pet.objectId == selectedPet?.objectId {
                    selected_reminders.append(reminder)
                }
            }
            var relation = selectedPet!.relationForKey("owners")
            relation.query()!.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if let error = error {
                    // There was an error
                    
                } else {
                    // objects has all the Posts the current user liked.
                    self.owners = (objects as? [PFUser])!
                }

                self.tableView.reloadData()
                self.removeAllOverlays()
            }


        }
    }
    
    
    
    @IBAction func addReminder(sender: AnyObject) {
        let button = sender as! UIButton
        button.animateSlingPress()
    }

    @IBAction func editPet(sender: AnyObject) {
        let button = sender as! UIButton
        button.animateSlingPress()
        
    }
    
    @IBAction func deletePet(sender: AnyObject) {
        let button = sender as! UIButton
        button.animateSlingPress()
        self.showWaitOverlay()
        selectedPet?.deleteInBackgroundWithBlock({ (success, error) -> Void in
            self.removeAllOverlays()
            NSNotificationCenter.defaultCenter().postNotificationName(reloadRequestNotificationKey, object: self)
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        
    }
    
    func getProfPic(fid: String) -> UIImage? {
        if (fid != "") {
            var imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=normal" //type=large
            var imgURL = NSURL(string: imgURLString)
            var imageData = NSData(contentsOfURL: imgURL!)
            var image = UIImage(data: imageData!)
            return image
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sectionsInTable.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return owners.count
        } else {
            return selected_reminders.count
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("OwnerCell", forIndexPath: indexPath) as! UITableViewCell
            
            if let uid = owners[indexPath.row]["uid"] as? String {
                cell.imageView?.image = getProfPic(uid)
            }

            if let first_name = owners[indexPath.row]["first_name"] as? String,
                let last_name = owners[indexPath.row]["last_name"] as? String {
                cell.textLabel?.text = "\(first_name) \(last_name)"
            }
            
            return cell
            
        } else {
         
            let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! ReminderTableViewCell
            cell.icon.image = selected_reminders[indexPath.row].getIcon()
            cell.name?.attributedText = selected_reminders[indexPath.row].getName()
            return cell
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    // print the date as the section header title
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsInTable[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 35 }
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(netHex: 0xF7F7FF)
        header.textLabel.textColor = UIColor(netHex: 0x8C8C99)
        header.textLabel.font = UIFont(name: "HelveticaNeue", size: 17)!
        
        switch (section) {
        case 0:
            header.textLabel.text = sectionsInTable[0]
        case 1:
            header.textLabel.text = sectionsInTable[1]
        default:
            header.textLabel.text = "other";
        }
        
//        header.frame
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 20))
        footerView.backgroundColor = UIColor(netHex: 0xF7F7FF)
        return footerView
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
