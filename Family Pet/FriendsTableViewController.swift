//
//  FriendsTableViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/12/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

var friendsSelected = [PFUser]()

class FriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var popupView: UIView!

    @IBOutlet var tableView: UITableView!
    var friends = [PFUser]()
    var selected = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popupView.layer.cornerRadius = 5
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.view.layer.shadowRadius = 40.0
        
        self.navigationItem.title = "Friends"
        
        loadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    func loadData(){
        self.showWaitOverlay()

        let request = FBSDKGraphRequest(graphPath:"me?fields=friends", parameters:nil)
        
        request.startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                var resultDict = result as! NSDictionary
                // println("Result Dict: \(resultdict)")
                var friendsDict : NSDictionary = resultDict.objectForKey("friends") as! NSDictionary
                var data : NSArray = friendsDict.objectForKey("data") as! NSArray
                
                var friendIds = [String]()
                
                for i in 0..<data.count {
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    let id = valueDict.objectForKey("id") as! String
                    
                    // unoptimized, needs reformat
                    self.selected.append(false)
                    for var j = 0; j < friendsSelected.count; j++ {
                        if id == friendsSelected[j]["uid"] as! String {
                            self.selected[i] = true
                            break
                        }
                    }
                    friendIds.append(id)
                    
                    // println("the id value is \(id)")
                }
                
                var friendQuery = PFUser.query()
                friendQuery?.whereKey("uid", containedIn: friendIds)
                
                friendQuery?.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                    if error == nil {
                        self.friends = results as! [PFUser]
                        self.tableView.reloadData()
                        self.removeAllOverlays()
                    }
                })
                
                println("Found \(data.count) friends")
            }
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        friendsSelected.removeAll(keepCapacity: false)
        for var i = 0; i < selected.count; i++ {
            if selected[i] {
                friendsSelected.append(friends[i])

            }
        }
        println("\(friendsSelected.count) friends selected.")
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

    @IBAction func cancel(sender: AnyObject) {
        let button = sender as! UIButton
        button.animateSlingPress()
        dismissViewControllerAnimated(true, completion: { () -> Void in })
    }
    @IBAction func close(sender: AnyObject) {
        let button = sender as! UIButton
        button.animateSlingPress()
        let parent = self.presentingViewController as! AddPetViewController
        dismissViewControllerAnimated(true, completion: { () -> Void in
            parent.setOwnersButtonTitle()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return friends.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! UITableViewCell
        let friend = friends[indexPath.row]
        if let first_name = friend["first_name"] as? String,
           let last_name = friend["last_name"] as? String {
            cell.textLabel?.text = "\(first_name) \(last_name)"
        } else {
            cell.textLabel?.text = "Name Pending"
        }
        if selected[indexPath.row] {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        cell.imageView?.image = getProfPic(friend["uid"] as! String)


        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        selected[indexPath.row] = true
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
        selected[indexPath.row] = false
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
