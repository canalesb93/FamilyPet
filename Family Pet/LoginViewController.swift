//
//  ViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    
    let facebook_permissions = ["public_profile", "email", "user_friends"]
    let feed_identifier = "FeedIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set Title w/ spacing
        let attributedString = NSMutableAttributedString(string: "family pet")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(5), range: NSRange(location: 0, length: 9))
        titleLabel.attributedText = attributedString

        

    }

    @IBAction func doConnect(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(facebook_permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
                self.performSegueWithIdentifier(self.feed_identifier, sender: nil)

            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

