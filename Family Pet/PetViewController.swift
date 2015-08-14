//
//  PetViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/13/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit

class PetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var petAttributesLabel: UILabel!
    @IBOutlet var petTypeLabel: UILabel!
    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var petProfile: PFImageView!
    @IBOutlet var tableView: UITableView!
    
    let sectionsInTable = ["owners", "reminders"]
    
    var owners = ["one", "two", "three", "four", "five"]
    
    var reminders = ["rone", "twor", "rthree", "fourr", "fiver"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petProfile.layer.cornerRadius = petProfile.frame.size.width / 2;
        petProfile.clipsToBounds = true
        petProfile.layer.borderWidth = 6.0;
        petProfile.layer.borderColor = UIColor(netHex: 0xE0D59F).CGColor
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
    
    func loadData(){
        if selectedPet != nil {
            self.navigationItem.title = selectedPet!.name
            petNameLabel.text = selectedPet!.name
            petTypeLabel.text = selectedPet?.getType()
            petAttributesLabel.text = selectedPet?.attributes
            
            petProfile.file = selectedPet?.image
            petProfile.loadInBackground()
        }
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
            return reminders.count
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("OwnerCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = owners[indexPath.row]
            return cell
            
        } else {
         
            let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! ReminderTableViewCell
            cell.name?.text = reminders[indexPath.row]
            return cell
            
        }
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
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
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
