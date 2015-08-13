//
//  ListViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

var selectedPet:Pet?
var selectedPetImage:UIImage?

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var petsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: globalNotificationKey, object: nil)
        
        petsTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        petsTable.tableFooterView = UIView(frame: CGRectZero)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func reloadData(){
        self.petsTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "Cell"
        var cell = petsTable.dequeueReusableCellWithIdentifier(identifier) as! PetTableViewCell
        
        
        cell.petProfile.layer.cornerRadius = cell.petProfile.frame.size.width / 2;
        cell.petProfile.clipsToBounds = true
        cell.petProfile.layer.borderWidth = 2.0;
        cell.petProfile.layer.borderColor = UIColor(netHex: 0xE0D59F).CGColor
        cell.petProfile.image = UIImage(named: "dogCamera")
        
        let pet = pets[indexPath.row]
        
        // load image
        if pet.image != nil {
            cell.petProfile.contentMode = UIViewContentMode.ScaleToFill
            cell.petProfile.file = pet.image
            cell.petProfile.loadInBackground(nil) { percent in
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
        selectedPet = pets[indexPath.row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
