//
//  ListViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

var pets = [Pet]()

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: PetScrollView!
    
    @IBOutlet var petsTable: UITableView!
    
    @IBAction func reload(sender: AnyObject) {
        loadPets()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petsTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        petsTable.tableFooterView = UIView(frame: CGRectZero)
        self.petsTable.addPullToRefresh({ [weak self] in
            self!.loadPets()
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Reload the wall
        loadPets()
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
                        self.petsTable.reloadData()
                        self.petsTable.stopPullToRefresh()
                        
                    }
                } else {
                    println("Error loading pets: \(error)")
                }
                
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "Cell"
        var cell = petsTable.dequeueReusableCellWithIdentifier(identifier) as! PetTableViewCell
        
        
        cell.petProfile.layer.cornerRadius = cell.petProfile.frame.size.width / 2;
        cell.petProfile.clipsToBounds = true
        cell.petProfile.layer.borderWidth = 6.0;
        cell.petProfile.layer.borderColor = UIColor(netHex: 0x4C4C4F).CGColor
        cell.petProfile.image = UIImage(named: "dogCamera")
        
        let pet = pets[indexPath.row]
        
        // load image
        if pet.image != nil {
            cell.petProfile.contentMode = UIViewContentMode.ScaleToFill
            cell.petProfile.file = pet.image
            cell.petProfile.loadInBackground(nil) { percent in
                cell.progressView.progress = Float(percent)*0.01
                // println("\(percent)%")
            }
        }
        
        if let name = pet.name as String! {
            // println("Added Cell for: \(name)")
            cell.name.text = name
        }
        if let description = pet.attributes as String! {
            cell.petDescription.text = description
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Selected row at index: \(indexPath.row)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
