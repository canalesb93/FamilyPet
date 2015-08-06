//
//  PagingViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit

class PagingViewController: UIViewController, PagingMenuControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CONFIGURING NAVBAR
        // let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(30)] as Dictionary!
        // userConfig.setTitleTextAttributes(attributes, forState: .Normal)
        // userConfig.tintColor = UIColor(netHex: 0x4C4C4F)
        // userConfig.title = String.fontAwesomeIconWithName(.Cog)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        
        
        // INITIATE PAGING MENU
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("PetsViewController") as! PetsViewController
        viewController.title = "pets"
        let viewController2 = self.storyboard?.instantiateViewControllerWithIdentifier("FeedViewController") as! FeedViewController
        viewController2.title = "feed"
        let viewController3 = self.storyboard?.instantiateViewControllerWithIdentifier("RemindersViewController") as! RemindersViewController
        viewController3.title = "reminders"
        let viewControllers = [viewController, viewController2, viewController3]
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        
        let options = PagingMenuOptions()
        
        options.backgroundColor = UIColor(netHex:0xF7F7FF)
        options.selectedBackgroundColor = UIColor(netHex:0x4C4C4F)
        options.animationDuration = NSTimeInterval(0.25)
        
        options.selectedTextColor = UIColor(netHex: 0xF7F7FF)
        options.textColor = UIColor(netHex: 0x4C4C4F)
        options.menuItemMode = PagingMenuOptions.MenuItemMode.None
        options.menuHeight = CGFloat(40.0)
        
        options.menuDisplayMode = PagingMenuOptions.MenuDisplayMode.FlexibleItemWidth(centerItem: true, scrollingMode: .PagingEnabled)
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        pagingMenuController.delegate = self

        // Do any additional setup after loading the view.
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
