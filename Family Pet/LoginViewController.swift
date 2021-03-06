//
//  ViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var intent = false
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var facebookButton: UIButton!
    
    let facebook_permissions = ["public_profile", "email", "user_friends"]
    let initial_segue_identifier = "PagingSegueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set Title w/ spacing
        let attributedString = NSMutableAttributedString(string: "family pet")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(5), range: NSRange(location: 0, length: 9))
        titleLabel.attributedText = attributedString

        

    }
    
    // Login user automatically
    override func viewDidAppear(animated: Bool) {
        if let user = PFUser.currentUser() {
            if user.isAuthenticated() && intent == false {
                
                associateDeviceWithUser()
                
                self.performSegueWithIdentifier(self.initial_segue_identifier, sender: facebookButton)
            }
        }
    }
    
    // Facebook Button
    @IBAction func doConnect(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(facebook_permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    // Create request for user's Facebook data
                    let request = FBSDKGraphRequest(graphPath:"me?fields=email,first_name,last_name", parameters:nil)
                    
                    // Send request to Facebook
                    request.startWithCompletionHandler { (connection, result, error) in
                        if error != nil {
                            // Some error checking here
                        }
                        else if let userData = result as? [String:AnyObject] {
                            println("Saving user data")
                            
                            // Access user data
                            let first_name = userData["first_name"] as? String
                            let last_name = userData["last_name"] as? String
                            let email = userData["email"] as? String
                            let uid = userData["id"] as? String
                            user["uid"] = uid
                            user["first_name"] = first_name
                            user["last_name"] = last_name
                            user["email"] = email
                            user.saveInBackgroundWithBlock({ (success, error) -> Void in
                                if success {
                                    self.associateDeviceWithUser()
                                    self.performSegueWithIdentifier(self.initial_segue_identifier, sender: nil)
                                }
                            })
                        }
                    }
                } else {
                    println("User logged in through Facebook!")
                    self.intent = true
                    self.associateDeviceWithUser()
                    self.performSegueWithIdentifier(self.initial_segue_identifier, sender: nil)
                }


            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    let transition = BubbleTransition()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? UIViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .Custom
        }
    }
    
    func associateDeviceWithUser(){
        // Associate the device with a user
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation.saveInBackground()
        println("Added user to device installation")
    }
    
    func getUserInfo(){
        

        
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = facebookButton.center
        transition.bubbleColor = UIColor(netHex: 0xF7F7FF)
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = facebookButton.center
        transition.bubbleColor = facebookButton.backgroundColor!
        return transition
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

