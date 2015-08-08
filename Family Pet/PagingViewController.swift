//
//  PagingViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit


var navBarHeight: CGFloat?
var pagingBarHeight: CGFloat?

class PagingViewController: UIViewController, PagingMenuControllerDelegate {

    var petScrollController: PetScrollViewController?
    var reminderScrollController: ReminderScrollViewController?
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CONFIGURING NAVBAR
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(30)] as Dictionary!
        // userConfig.setTitleTextAttributes(attributes, forState: .Normal)
        // userConfig.tintColor = UIColor(netHex: 0x4C4C4F)
        // userConfig.title = String.fontAwesomeIconWithName(.Cog)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        navBarHeight = self.navigationController?.navigationBar.frame.size.height
        pagingBarHeight = CGFloat(40.0)
        
        // INITIATE PAGING MENU
        petScrollController = self.storyboard?.instantiateViewControllerWithIdentifier("PetScrollViewController") as? PetScrollViewController
        petScrollController!.title = "pets"
        let feedController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedViewController") as! FeedViewController
        feedController.title = "feed"
        reminderScrollController = self.storyboard?.instantiateViewControllerWithIdentifier("ReminderScrollViewController") as? ReminderScrollViewController
        reminderScrollController!.title = "reminders"
        let viewControllers = [petScrollController!, feedController, reminderScrollController!]
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        
        let options = PagingMenuOptions()
        
        options.backgroundColor = UIColor(netHex:0xF7F7FF)
        options.selectedBackgroundColor = UIColor(netHex:0x4C4C4F)
        options.animationDuration = NSTimeInterval(0.25)
        
        options.selectedTextColor = UIColor(netHex: 0xF7F7FF)
        options.textColor = UIColor(netHex: 0x4C4C4F)
        options.font = UIFont(name: "HelveticaNeue-Light", size: 18)!


        options.menuItemMode = PagingMenuOptions.MenuItemMode.None
        options.menuHeight = pagingBarHeight!
        options.menuDisplayMode = PagingMenuOptions.MenuDisplayMode.FlexibleItemWidth(centerItem: false, scrollingMode: .PagingEnabled)
        
        options.defaultPage = currentPage
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        pagingMenuController.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func willMoveToMenuPage(page: Int) {
        if page == 1 {
            if currentPage == 0 && petScrollController != nil {
                petScrollController!.moveToView(0)
            } else if currentPage == 2 && reminderScrollController != nil {
                reminderScrollController!.moveToView(0)
            }
        }
    }
    
    func didMoveToMenuPage(page: Int) {
        currentPage = page
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
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
